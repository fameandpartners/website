import React, {Component, PropTypes,} from 'react';

class LeftHandNav extends Component {
    constructor() {
        super()
        this.state = {
          activeID: 'dresses',
          activeSubcategory: 'maxi',
          categories: [
            {
              id: 'dresses',
              displayName: 'Dresses',
              relativePath: '/dresses',
              subCategories: [
                {
                  label: null,
                  subItems: [
                    {
                      id: 'maxi',
                      count: 22,
                      displayName: 'Maxi',
                      relativePath: '/dresses/long'
                    }, {
                      id: 'midi',
                      count: 10,
                      displayName: 'Midi',
                      relativePath: '/dresses/midi'
                    }, {
                      id: 'mini',
                      count: 44,
                      displayName: 'Mini',
                      relativePath: '/dresses/mini'
                    }, {
                      id: 'twoPiece',
                      count: 22,
                      displayName: 'Two Piece',
                      relativePath: '/dresses/two-piece'
                    }
                  ]
                }, {
                  label: 'Event',
                  subItems: [
                    {
                      id: 'prom',
                      count: 10,
                      displayName: 'Prom',
                      relativePath: '/dresses/prom'
                    }, {
                      id: 'bridal',
                      count: 22,
                      displayName: 'Bridal',
                      relativePath: '/dresses/bridal'
                    }, {
                      id: 'bridesmaid',
                      count: 43,
                      displayName: 'Bridesmaid',
                      relativePath: '/dresses/bridesmaid'
                    }, {
                      id: 'wedding',
                      count: 32,
                      displayName: 'Wedding Guests',
                      relativePath: '/dresses/wedding-guests'
                    }, {
                      id: 'cocktail',
                      count: 34,
                      displayName: 'Cocktail',
                      relativePath: '/dresses/cocktail'
                    }, {
                      id: 'graduation',
                      count: 56,
                      displayName: 'Graduation',
                      relativePath: '/dresses/graduation'
                    }
                  ]
                }
              ]
            }, {
              id: 'skirts',
              displayName: 'Skirts',
              relativePath: '/skirts'
            }, {
              id: 'jumpsuits',
              displayName: 'Jumpsuits & Rompers',
              relativePath: '/dresses/jumpsuit' 
            }, {
              id: 'tops',
              displayName: 'Tops',
              relativePath: '/tops'
            }, {
              id: 'pants',
              displayName: 'Pants',
              relativePath: '/pants'
            }, {
              id: 'outerwear',
              displayName: 'Outerwear & Jackets',
              relativePath: '/outerwear-and-jackets'
            }
          ]
        }
    }
    render() {
      let { categories, activeID, activeSubcategory } = this.state
      return (
        <div>
            <h1 onClick={() => this.setState({ activeID: Math.random() })}>Active Category: {activeID}</h1>
            <ul>
              {categories.map(c => {
                // Dresses logic
                if(c.subCategories) {
                  let subCategories = c.subCategories
                  if(activeID === c.id) {
                    return (
                    <li onClick={() => this.setState({ activeID: c.id })}>
                        <b>{c.displayName}</b>
                        {subCategories.map(s => {
                          return (
                            <li>
                              <p>{s.label}</p>
                              <ul>
                                {s.subItems.map(i => {
                                  if(i.id === activeSubcategory) {
                                    return <b>{i.displayName}</b>
                                  }
                                  return (
                                    <li>
                                      <a href={`#${i.relativePath}`}>{i.displayName}</a>
                                    </li>
                                  )
                                })}
                              </ul>
                            </li>
                          )
                        })}
                    </li>
                    )
                  }
                  else {
                    <li onClick={() => this.setState({ activeID: c.id })}>
                      <a href={`#${c.relativePath}`}>{c.displayName}</a>
                    </li>
                  }                
                }
                else if(activeID === c.id) {
                  return <b>{c.displayName}</b>
                }
                return (
                  <li onClick={() => this.setState({ activeID: c.id })}>
                    <a href={`#${c.relativePath}`}>{c.displayName}</a>
                  </li>
                )
              })}
            </ul>
        </div>
      );
    }
}

export default LeftHandNav
