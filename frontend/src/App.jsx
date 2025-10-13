import { useState, useRef, useEffect } from 'react'
import './App.css'
import Header from './components/Header'
import SearchBar from './components/SearchBar'
import Results from './components/Results'
import axios from 'axios'

function App() {
  const [results, setResults] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [searchQuery, setSearchQuery] = useState('')

  const handleSearch = async (query) => {
    setLoading(true)
    setError(null)
    setSearchQuery(query)

    try {
      const response = await axios.post('http://localhost:5000/api/search', {
        query: query
      })

      if (response.data.success) {
        setResults(response.data.results)
      } else {
        setError('Erro ao buscar resultados')
      }
    } catch (err) {
      setError('Erro ao conectar com o servidor. Verifique se o backend está rodando.')
      console.error('Erro:', err)
    } finally {
      setLoading(false)
    }
  }

  const resultsRef = useRef(null)

  useEffect(() => {
    if (!loading && results.length > 0) {
      const el = resultsRef.current
      if (!el) return

      const header = document.querySelector('header.header')
      const headerHeight = header ? header.getBoundingClientRect().height + 16 : 88

      const rect = el.getBoundingClientRect()
      const scrollTop = window.pageYOffset + rect.top - headerHeight

      window.scrollTo({ top: scrollTop, behavior: 'smooth' })
    }
  }, [loading, results])

  return (
    <div className="App">
      <Header />
      <main className="container">
        <div className="hero">
          <h1>Descubra seu Mercado</h1>
          <p>Encontre concorrentes e tendências com inteligência artificial</p>
        </div>

        <SearchBar onSearch={handleSearch} loading={loading} />

        {error && (
          <div className="error-message">
            <p>{error}</p>
          </div>
        )}

        {loading && (
          <div className="loading">
            <div className="spinner"></div>
            <p>Buscando informações...</p>
          </div>
        )}

        {!loading && results.length > 0 && (
          <div ref={resultsRef}>
            <Results results={results} query={searchQuery} />
          </div>
        )}
      </main>
    </div>
  )
}

export default App
