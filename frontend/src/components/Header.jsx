import React from 'react'
import './Header.css'
import intelluxLogo from './assets/intellux_logo.webp'

function Header() {
  return (
    <header className="header">
      <div className="header-content">
        <div className="logo">
          <img src={intelluxLogo} alt="Intellux Logo" className="logo-image" />
        </div>
      </div>
    </header>
  )
}

export default Header
