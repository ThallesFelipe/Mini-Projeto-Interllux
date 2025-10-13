import React from 'react'
import './Results.css'
import CompanyCard from './CompanyCard'

function Results({ results, query }) {
  return (
    <div className="results">
      <div className="results-header">
        <h2>Resultados para: <span>“{query}”</span></h2>
        <p>Encontramos {results.length} empresas relacionadas</p>
      </div>

      <div className="results-grid">
        {results.map((company, index) => (
          <CompanyCard key={index} company={company} index={index} />
        ))}
      </div>
    </div>
  )
}

export default Results
