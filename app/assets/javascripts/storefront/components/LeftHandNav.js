import React, {Component} from 'react';
import SubCategoryList from './SubCategoryList'
import categoryTypes from '../constants/productCategoryConstants'

class LeftHandNav extends Component {
    constructor() { 
        super()
        const currentURL   = window.location.pathname.replace('/', '')
        const mainCategory = currentURL.split('/')[0]
        const subCategory  = currentURL.split('/')[1]
        this.state = {
          activeCategory: mainCategory,
          activeSubCategory: subCategory,
          categories: categoryTypes
        }
    }
    render() {
      const { categories, activeCategory, activeSubCategory } = this.state
      const hideDressLinks = activeCategory === 'dresses' && activeSubCategory === 'jumpsuit'
      let categoryStyle
      activeSubCategory ? categoryStyle = 'navigation-link' : categoryStyle = 'navigation-link navigation-link--active'
      return (
        <div className="LeftHandNav__Container">
            <div className="ExpandablePanel__heading">
                <span className="ExpandablePanel__mainTitle">Clothing</span>
            </div>
            <ul className="Category__Container">
              {categories.map(c => {
                if(c.subCategories && !hideDressLinks) {
                  if(c.id === activeCategory) {
                    return (
                      <li key={c.id} className="active-category">
                          <div className="subcategory-available">
                              <div className="ExpandablePanel__name active"></div>
                              <a 
                                href={c.relativePath}
                                className={categoryStyle}
                              >
                              {c.displayName}
                              </a>
                              <SubCategoryList 
                                subCategoryData={c.subCategories} 
                                activeSubCategory={activeSubCategory}
                              />
                          </div>
                      </li>
                    )
                  }                             
                }
                if(c.subCategories) {
                  return (
                    <li key={c.id}>
                        <div className="subcategory-available">
                          <div className="ExpandablePanel__name"></div>
                          <a 
                            href={c.relativePath}
                            className="navigation-link"
                          >
                          {c.displayName}
                          </a>
                        </div>
                    </li>
                  )
                }
                else if(c.id === activeCategory && !hideDressLinks) {
                  return (
                    <span 
                      className="navigation-link navigation-link--active" 
                      key={c.id}
                    >
                      {c.displayName}
                    </span>
                  )
                }
                else if(c.id === activeSubCategory && hideDressLinks) {
                  // Jumpsuits & Rompers
                  return (
                    <span className="navigation-link navigation-link--active" key={c.id}>
                        {c.displayName}
                    </span>
                  )
                }
                return (
                  <li key={c.id}>
                    <a href={c.relativePath} className="navigation-link">
                      {c.displayName}
                    </a>
                  </li>
                )
              })}
            </ul>
        </div>
      );
    }
}

export default LeftHandNav