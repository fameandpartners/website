import React, {Component, PropTypes,} from 'react';
import SubCategoryList from './SubCategoryList'
class LeftHandNav extends Component {
    constructor() { 
        super()
        this.state = {
          activeCategory: '',
          activeSubcategory: '',
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
                      id: 'two-piece',
                      count: 22,
                      displayName: 'Two Piece',
                      relativePath: '/dresses/two-piece'
                    }
                  ]
                }, {
                  label: 'By Event',
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
                      id: 'wedding-guests',
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
              id: 'jumpsuit',
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
              relativePath: '/outerwear'
            }
          ]
        }
    }
    componentWillMount() {
      let mainCategory = window.location.pathname
      mainCategory = mainCategory.replace('/', '').split('/')[0]
      let subCategory = window.location.pathname.replace(`/${mainCategory}`, '').replace('/', '')
      this.setState({
        activeCategory: mainCategory,
        activeSubcategory: subCategory
      });
    }
    render() {
      let { categories, activeCategory, activeSubcategory } = this.state
      let hideDressLinks = activeCategory === 'dresses' && activeSubcategory === 'jumpsuit'
      return (
        <div className="LeftHandNav--container">
            <div className="ExpandablePanel__heading">
                <span className="ExpandablePanel__mainTitle">Clothing</span>
            </div>
            <ul className="LeftHandNav__categoryContainer">
              {categories.map(c => {
                if(c.subCategories && !hideDressLinks) {
                  let subCategories = c.subCategories
                  if(activeCategory === c.id) {
                    return (
                      <li 
                        className="LeftHandNav__subcategoryContainer"
                        key={Math.random()}>
                          <div>
                              <b >{c.displayName}</b>
                              <SubCategoryList 
                                subCategoryData={subCategories} 
                                activeSubcategory={activeSubcategory}
                              />
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
                else if(activeCategory === c.id && !hideDressLinks) {
                  return <b key={Math.random()}>{c.displayName}</b>
                }
                else if(c.id === activeSubcategory) {
                  // Jumpsuits & Rompers
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
