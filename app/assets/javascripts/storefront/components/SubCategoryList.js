import React, {Component, PropTypes,} from 'react';
class SubCategoryList extends Component {
    constructor() {
        super()
        this.state = {
          subCategories: [],
          activeSubCategory: '',
        }
    }
    componentWillMount() {
      this.setState({
        subCategories: this.props.subCategoryData,
        activeSubCategory: this.props.activeSubCategory
      });
    }
    render() {
      let { subCategories, activeSubCategory } = this.state
      return (
        <div>
            {subCategories.map(s => {
              return (
                <div key={Math.random()}>
                  <ul className="LeftHandNav__subcategoryList">
                    {s.label ?  <li className="LeftHandNav__categoryLabel">{s.label}</li> : ''}
                    {s.subItems.map(i => {
                      if(i.id === activeSubCategory) {
                        return (
                          <b 
                            key={i.id}
                            className="LeftHandNav__activeLink"
                          >
                            {i.displayName}
                          </b>
                        )
                      }
                      return (
                        <li key={i.id}>
                          <a 
                            href={i.relativePath}
                          >
                            {i.displayName}
                          </a>
                        </li>
                      )
                    })}
                  </ul>
                </div>
              )
            })}
        </div>
      );
    }
}

export default SubCategoryList
