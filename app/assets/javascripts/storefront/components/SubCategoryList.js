import React, {Component, PropTypes,} from 'react';
class SubCategoryList extends Component {
    constructor() {
        super()
        this.state = {
          subCategories: [],
          activeSubcategory: '',
        }
    }
    componentWillMount() {
      this.setState({
        subCategories: this.props.subCategoryData,
        activeSubcategory: this.props.activeSubcategory
      });
    }
    render() {
      let { subCategories, activeSubcategory } = this.state
      return (
        <div>
            {subCategories.map(s => {
              return (
                <div key={Math.random()}>
                  <ul className="LeftHandNav__subcategoryList">
                    {s.label ?  <li className="LeftHandNav__categoryLabel">{s.label}</li> : ''}
                    {s.subItems.map(i => {
                      if(i.id === activeSubcategory) {
                        return (
                          <b 
                            key={Math.random()}
                            className="LeftHandNav__activeLink"
                          >
                            {i.displayName}
                          </b>
                        )
                      }
                      return (
                        <li key={Math.random()}>
                          <a 
                            target="_blank" 
                            href={`${i.relativePath}`}
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
