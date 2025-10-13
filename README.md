# Intellux - Pesquisa de Concorrentes

Projeto desenvolvido para buscar informações sobre empresas concorrentes usando IA.

## O que esse projeto faz?

É uma aplicação web onde você digita um setor (exemplo: "marketing digital", "restaurantes", "tecnologia") e ela retorna uma lista de 5 empresas que atuam naquela área, mostrando:

- Nome da empresa
- Descrição do que ela faz
- Principais serviços oferecidos
- Site oficial
- Pontos fortes

Tudo isso é gerado automaticamente usando a API do Google Gemini!

## 🛠️ Tecnologias Utilizadas

**Backend:**
- Python 3
- Flask (servidor web)
- Google Gemini API (IA para buscar informações)
- Flask-CORS (para conectar frontend e backend)

**Frontend:**
- React
- Vite (para rodar o projeto)
- CSS puro

## 📦 Como Rodar o Projeto

### Pré-requisitos
- Python 3.10 ou superior instalado
- Node.js instalado
- Uma chave da API do Google Gemini

### Passo 1: Clonar o repositório
```bash
git clone https://github.com/ThallesFelipe/Mini-Projeto-Interllux.git
cd Mini-Projeto-Interllux
```

### Passo 2: Configurar a API Key
1. Acesse https://makersuite.google.com/app/apikey e pegue sua chave
2. Abra o arquivo `backend/.env`
3. Cole sua chave no lugar de `your_api_key_here`

### Passo 3: Instalar tudo
```bash
.\setup.ps1
```

Este script vai instalar todas as dependências automaticamente.

### Passo 4: Rodar o projeto
```bash
.\start.ps1
```

O projeto vai abrir em:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000

## 💡 Decisões Técnicas

**Por que Flask?**
É simples e rápido para criar APIs. Como o projeto é pequeno, não precisava de algo mais complexo.

**Por que Gemini?**
É gratuito e muito bom para gerar textos estruturados.

**Por que React?**
Facilita criar componentes reutilizáveis (como os cards das empresas) e gerenciar o estado da aplicação.

**Estrutura do projeto:**
- Separei frontend e backend em pastas diferentes para organizar melhor
- Criei scripts PowerShell para facilitar a instalação e execução
- Usei variáveis de ambiente (.env) para proteger a API key

## ⚠️ Limitações

- **Informações nem sempre precisas:** A IA pode inventar algumas coisas ou dar informações desatualizadas
- **Limite de requisições:** A API do Gemini tem limites gratuitos.
- **Não busca na internet de verdade:** A IA usa conhecimento que já tem, não faz web scraping em tempo real
- **Sem banco de dados:** As buscas não ficam salvas
- **Sem autenticação:** Qualquer um com o link pode usar

## 🔮 Próximos Passos

Se eu tivesse mais tempo, faria:

1. **Salvar histórico:** Adicionar um banco de dados para guardar as pesquisas antigas
2. **Exportar relatórios:** Botão para baixar os resultados em PDF
3. **Mais filtros:** Permitir filtrar por localização, tamanho da empresa, etc.
4. **Comparação:** Adicionar uma tela para comparar empresas lado a lado
5. **Gráficos:** Mostrar dados visuais sobre o mercado
6. **Web scraping real:** Buscar dados atualizados direto dos sites das empresas
7. **Autenticação:** Login para cada usuário ter suas próprias pesquisas

## 📝 Observações

- Se der erro, verifique se as portas 3000 e 5000 estão livres

---
