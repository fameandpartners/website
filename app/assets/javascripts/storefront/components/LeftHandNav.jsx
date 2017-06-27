import React, {Component, PropTypes,} from 'react';
import SubCategoryList from './SubCategoryList'
import categoryTypes from '../constants/productCategoryConstants'
class LeftHandNav extends Component {
    constructor() { 
        super()
        this.state = {
          activeCategory: '',
          activeSubCategory: '',
          categories: categoryTypes
        }
    }
    componentWillMount() {
      let mainCategory = window.location.pathname
      mainCategory = mainCategory.replace('/', '').split('/')[0]
      const subCategory = window.location.pathname.replace(`/${mainCategory}`, '').replace('/', '')
      this.setState({
        activeCategory: mainCategory,
        activeSubCategory: subCategory
      });
    }
    render() {
      const { categories, activeCategory, activeSubCategory } = this.state
      const hideDressLinks = activeCategory === 'dresses' && activeSubCategory === 'jumpsuit'
      let categoryStyle
      activeSubCategory.length > 1 ? categoryStyle = 'LeftHandNav--inActiveLink' : categoryStyle = 'LeftHandNav__activeLink'
      return (
        <div className="LeftHandNav__container">
            <div className="ExpandablePanel__heading">
                <span className="ExpandablePanel__mainTitle">Clothing</span>
            </div>
            <ul className="LeftHandNav--categoryContainer">
              {categories.map(c => {
                if(c.subCategories && !hideDressLinks) {
                  const subCategories = c.subCategories
                  if(activeCategory === c.id) {
                    return (
                      <li 
                        className="LeftHandNav--subcategoryContainer"
                        key={c.id}>
                          <div>                              
                              <a 
                                href={c.relativePath}
                                className={categoryStyle}
                              >
                                {c.displayName}
                              </a>
                              <SubCategoryList 
                                subCategoryData={subCategories} 
                                activeSubCategory={activeSubCategory}
                              />
                          </div>
                      </li>
                    )
                  }               
                }
                else if(c.id === activeCategory  && !hideDressLinks) {
                  return <span className="LeftHandNav--activeLink" key={c.id}>{c.displayName}</span>
                }
                else if(c.id === activeSubCategory) {
                  // Jumpsuits & Rompers
                  return <span className="LeftHandNav--activeLink" key={c.id}>{c.displayName}</span>
                }
                return (
                  <li key={c.id}>
                    <a href={{c.relativePath}}>{c.displayName}</a>
                  </li>
                )
              })}
            </ul>
        </div>
      );
    }
}

export default LeftHandNav
