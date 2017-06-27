import React, {Component, PropTypes} from 'react';

class SubCategoryList extends Component {
    constructor(props) {
        super(props)
        this.state = {
          subCategory: this.props.subCategoryData,
          activeSubCategory: this.props.activeSubCategory
        }
    }
    render() {
      let { subCategory, activeSubCategory } = this.state
      return (
        <div>
          <ul className="LeftHandNav__subcategoryList">
            {subCategory.map(s => {
              if(s.id === activeSubCategory) {
                return (
                  <span key={s.id} className="navigation-link--active">
                    {s.displayName}
                  </span>
                )
              }
              return (
                <li key={s.id}>
                  <a 
                    href={s.relativePath} className="navigation-link"
                  >
                    {s.displayName}
                  </a>
                </li>
              )
            })}
          </ul>
        </div>
      );
    }
}

SubCategoryList.propTypes = {
  activeSubCategory: PropTypes.string.isRequired,
  subCategoryData: PropTypes.arrayOf.isRequired
};

export default SubCategoryList