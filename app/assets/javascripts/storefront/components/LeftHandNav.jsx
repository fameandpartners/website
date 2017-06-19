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
    componentWillMount() {
      let url = url.replace('/', '').split('/')[0]
      console.log("url", url)
    }
    render() {
      let { categories, activeID, activeSubcategory } = this.state
      return (
        <div className="">
            <div className="ExpandablePanel__heading">
                <span className="ExpandablePanel__mainTitle">Clothing</span>
            </div>
            <ul className="LeftHandNav--container">
              {categories.map(c => {
                // Dresses logic
                if(c.subCategories) {
                  let subCategories = c.subCategories
                  if(activeID === c.id) {
                    return (
                    <li key={Math.random()}>
                        <div>
                            <b>{c.displayName}</b>
                            {subCategories.map(s => {
                              return (
                                <div key={Math.random()}>
                                  { s.label ?  <a href="#">{s.label}</a> : ''  }
                                  <ul>
                                    {s.subItems.map(i => {
                                      if(i.id === activeSubcategory) {
                                        return <b key={Math.random()}>{i.displayName}</b>
                                      }
                                      return (
                                        <li key={Math.random()}>
                                          <a target="_blank" href={`${i.relativePath}`}>{i.displayName}</a>
                                        </li>
                                      )
                                    })}
                                  </ul>
                                </div>
                              )
                            })}
                        </div>
                    </li>
                    )
                  }
                  else {
                    <li key={Math.random()}>
                      <a target="_blank" href={`${c.relativePath}`}>{c.displayName}</a>
                    </li>
                  }                
                }
                else if(activeID === c.id) {
                  return <b key={Math.random()}>{c.displayName}</b>
                }
                return (
                  <li key={Math.random()}>
                    <a target="_blank" href={`${c.relativePath}`}>{c.displayName}</a>
                  </li>
                )
              })}
            </ul>
        </div>
      );
    }
}

export default LeftHandNav
