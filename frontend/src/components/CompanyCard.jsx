import React from 'react'
import './CompanyCard.css'

function CompanyCard({ company, index }) {
  const formatAsList = (text) => {
    if (!text) return null;

    const separators = [',', ';', '•', '-', '|'];
    let items = [text];

    for (const sep of separators) {
      if (text.includes(sep)) {
        items = text.split(sep).map(item => item.trim()).filter(item => item.length > 0);
        break;
      }
    }

    if (items.length > 1) {
      return (
        <ul>
          {items.map((item, idx) => (
            <li key={idx}>{item}</li>
          ))}
        </ul>
      );
    }

    return <p>{text}</p>;
  };

  return (
    <div
      className="company-card"
      style={{ animationDelay: `${index * 0.1}s` }}
    >
      <div className="card-header">
        <div className="company-number">#{index + 1}</div>
        <h3>{company.name || 'Empresa'}</h3>
      </div>

      <div className="card-body">
        {company.description && (
          <div className="card-section">
            <h4>Sobre</h4>
            <p>{company.description}</p>
          </div>
        )}

        {company.services && (
          <div className="card-section">
            <h4>Serviços & Produtos</h4>
            {formatAsList(company.services)}
          </div>
        )}

        {company.strengths && (
          <div className="card-section">
            <h4>Pontos Fortes</h4>
            {formatAsList(company.strengths)}
          </div>
        )}

        {company.website && company.website !== 'N/A' && (
          <div className="card-footer">
            <a
              href={company.website.startsWith('http') ? company.website : `https://${company.website}`}
              target="_blank"
              rel="noopener noreferrer"
              className="website-link"
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M10 6H6C4.89543 6 4 6.89543 4 8V18C4 19.1046 4.89543 20 6 20H16C17.1046 20 18 19.1046 18 18V14M14 4H20M20 4V10M20 4L10 14" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
              Visitar website
            </a>
          </div>
        )}
      </div>
    </div>
  )
}

export default CompanyCard
