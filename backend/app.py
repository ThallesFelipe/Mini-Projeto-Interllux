from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv
import google.generativeai as genai
import traceback

load_dotenv()

app = Flask(__name__)
CORS(app)

api_key = os.getenv('GOOGLE_API_KEY')
if not api_key:
    print("ERRO: GOOGLE_API_KEY não encontrada no arquivo .env")
else:
    print(f"API Key carregada: {api_key[:10]}...")
    
genai.configure(api_key=api_key)
model = genai.GenerativeModel('gemini-2.0-flash')

@app.route('/api/search', methods=['POST'])
def search():
    try:
        data = request.get_json()
        query = data.get('query', '')
        
        if not query:
            return jsonify({'error': 'Query é obrigatória'}), 400
        
        # Prompt para buscar informações sobre empresas concorrentes
        prompt = f"""
        Você é um assistente de pesquisa de mercado para a Intellux, uma startup de marketing.
        
        Pesquise e forneça informações sobre 5 empresas que atuam no setor de: "{query}"
        
        Para CADA EMPRESA, forneça EXATAMENTE neste formato:
        
        EMPRESA: [Nome da Empresa]
        DESCRICAO: [Uma descrição breve de 2-3 linhas sobre o que a empresa faz e seu posicionamento no mercado]
        SERVICOS: [Liste os principais serviços/produtos separados por vírgula, exemplo: Serviço 1, Serviço 2, Serviço 3]
        WEBSITE: [URL do site oficial, se conhecer. Caso contrário, escreva "N/A"]
        FORCAS: [Liste os pontos fortes separados por vírgula, exemplo: Força 1, Força 2, Força 3]
        
        ---
        
        Repita este formato para as 5 empresas. Seja específico e detalhado. Use vírgulas para separar itens nas listas de SERVICOS e FORCAS.
        """
        
        # Gerar resposta usando Gemini
        response = model.generate_content(prompt)
        
        # Processar a resposta para estruturar os dados
        companies = parse_gemini_response(response.text)
        
        return jsonify({
            'success': True,
            'query': query,
            'results': companies,
            'raw_response': response.text
        })
        
    except Exception as e:
        print(f"\n{'='*50}")
        print(f"ERRO ao processar busca:")
        print(f"Query: {query if 'query' in locals() else 'N/A'}")
        print(f"Erro: {str(e)}")
        print(f"Tipo: {type(e).__name__}")
        print(f"Traceback:")
        traceback.print_exc()
        print(f"{'='*50}\n")
        
        return jsonify({
            'success': False,
            'error': f'{type(e).__name__}: {str(e)}'
        }), 500

def parse_gemini_response(text):
    """
    Processa a resposta do Gemini e estrutura em formato de lista
    """
    companies = []
    lines = text.split('\n')
    
    current_company = {}
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
        
        # Detectar separador de empresas
        if line.startswith('---'):
            if current_company and current_company.get('name'):
                companies.append(current_company)
                current_company = {}
            continue
        
        # Extrair campos específicos
        if line.startswith('EMPRESA:'):
            if current_company and current_company.get('name'):
                companies.append(current_company)
            current_company = {}
            current_company['name'] = line.replace('EMPRESA:', '').strip()
        elif line.startswith('DESCRICAO:'):
            current_company['description'] = line.replace('DESCRICAO:', '').strip()
        elif line.startswith('SERVICOS:'):
            current_company['services'] = line.replace('SERVICOS:', '').strip()
        elif line.startswith('WEBSITE:'):
            website = line.replace('WEBSITE:', '').strip()
            current_company['website'] = website if website != 'N/A' else None
        elif line.startswith('FORCAS:'):
            current_company['strengths'] = line.replace('FORCAS:', '').strip()
    
    # Adicionar última empresa
    if current_company and current_company.get('name'):
        companies.append(current_company)
    
    # Se não conseguiu parsear, tentar formato alternativo
    if len(companies) == 0:
        # Tentar parsear formato mais livre
        current_company = {}
        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            # Detectar nome da empresa (geralmente em negrito ou numerado)
            if ('**' in line or line[0].isdigit()) and not current_company.get('name'):
                name = line.replace('**', '').replace('*', '').strip()
                name = name.lstrip('0123456789.- ')
                if name:
                    if current_company and current_company.get('description'):
                        companies.append(current_company)
                    current_company = {'name': name}
            elif current_company.get('name'):
                # Adicionar informações sequencialmente
                if not current_company.get('description'):
                    current_company['description'] = line
                elif not current_company.get('services'):
                    current_company['services'] = line
                elif 'http' in line.lower() or 'www' in line.lower():
                    current_company['website'] = line
                elif not current_company.get('strengths'):
                    current_company['strengths'] = line
        
        if current_company and current_company.get('name'):
            companies.append(current_company)
    
    # Garantir que todos os campos existam
    for company in companies:
        if not company.get('description'):
            company['description'] = 'Empresa atuante no setor pesquisado'
        if not company.get('services'):
            company['services'] = 'Serviços especializados no mercado'
        if not company.get('strengths'):
            company['strengths'] = 'Experiência e qualidade no atendimento'
    
    return companies[:5]  # Limitar a 5 empresas

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok', 'message': 'API Intellux is running'})

if __name__ == '__main__':
    app.run(debug=True, port=5000)
