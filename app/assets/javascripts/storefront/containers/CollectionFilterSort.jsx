import React, {Component, PropTypes} from 'react';
import {connect} from 'react-redux';
// import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions'

//Libraries
import Resize from '../decorators/Resize.jsx';
import breakpoints from '../libs/breakpoints';

// Components
import ExpandablePanelItem from '../components/ExpandablePanelItem.jsx';

function stateToProps(state) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        return {colors: state.$$collectionFilterSortStore.get('$$colors').toJS()};
    }
    return {};
}

class CollectionFilterSort extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        const {dispatch, CollectionFilterSortState} = this.props;

        return (
            <div className="CollectionFilterSort">
                <div className="FilterSort">
                    <div className="ExpandablePanel">
                        <div className="ExpandablePanel__heading">
                            <span className="ExpandablePanel__mainTitle">R.Filter & sort by</span>
                            <a className="ExpandablePanel__clearAll js-trigger-clear-all-filters" href="javascript:;">Clear All</a>
                        </div>

                        <ExpandablePanelItem
                          itemGroup={(
                            <div>
                              <div className="ExpandablePanel__name">
                                Sort
                              </div>
                              <div className="ExpandablePanel__selectedOptions">
                                <span className="ExpandablePanel__selectedItem">What's new!!</span>
                              </div>
                            </div>
                          )}
                          revealedContent={(
                            <div>
                              <label className="ExpandablePanel__option" name="sort-price-high"><input id="sort-price-high" name="sort-price-high" type="checkbox" value="true"/>
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">Price High</span>
                                </span>
                              </label>
                              <label className="ExpandablePanel__option" name="sort-price-low"><input id="sort-price-low" name="sort-price-low" type="checkbox" value="true"/>
                                <span className="checkboxBlackBg__check">
                                  <span className="ExpandablePanel__optionName">Price Low</span>
                                </span>
                            </label>
                            </div>
                          )}
                        />
                        <div className="ExpandablePanelItem ExpandablePanelItem--is-active">
                            <div className="ExpandablePanel__name">
                                Color
                            </div>
                            <div className="ExpandablePanel__selectedOptions">
                                <span className="ExpandablePanel__selectedItem">Black</span>
                                <span className="ExpandablePanel__selectedItem">White</span>
                                <span className="ExpandablePanel__selectedItem">Red</span>
                                <span className="ExpandablePanel__selectedItem">Silver</span>
                                <span className="ExpandablePanel__selectedItem">Grey</span>
                                <span className="ExpandablePanel__selectedItem">Green</span>
                            </div>
                            <div className="ExpandablePanel__listOptions ExpandablePanel__listOptions--panelColors">
                                <div className="ExpandablePanel__listTwoColumns">
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver"><input data-all="false" id="color-silver" name="color-silver" type="checkbox" value="silver"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver"></span>
                                        <span className="ExpandablePanel__optionName">silver</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="purple"><input data-all="false" id="color-purple" name="color-purple" type="checkbox" value="purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-purple"></span>
                                        <span className="ExpandablePanel__optionName">purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="yellow"><input data-all="false" id="color-yellow" name="color-yellow" type="checkbox" value="yellow"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-yellow"></span>
                                        <span className="ExpandablePanel__optionName">yellow</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="nude"><input data-all="false" id="color-nude" name="color-nude" type="checkbox" value="nude"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-nude"></span>
                                        <span className="ExpandablePanel__optionName">nude</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="white"><input data-all="false" id="color-white" name="color-white" type="checkbox" value="white"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-white"></span>
                                        <span className="ExpandablePanel__optionName">white</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="blue"><input data-all="false" id="color-blue" name="color-blue" type="checkbox" value="blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-blue"></span>
                                        <span className="ExpandablePanel__optionName">blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="green"><input data-all="false" id="color-green" name="color-green" type="checkbox" value="green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-green"></span>
                                        <span className="ExpandablePanel__optionName">green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black"><input data-all="false" id="color-black" name="color-black" type="checkbox" value="black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black"></span>
                                        <span className="ExpandablePanel__optionName">black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink"><input data-all="false" id="color-pink" name="color-pink" type="checkbox" value="pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink"></span>
                                        <span className="ExpandablePanel__optionName">pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="red"><input data-all="false" id="color-red" name="color-red" type="checkbox" value="red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-red"></span>
                                        <span className="ExpandablePanel__optionName">red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pastel"><input data-all="false" id="color-pastel" name="color-pastel" type="checkbox" value="pastel"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pastel"></span>
                                        <span className="ExpandablePanel__optionName">pastel</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="blue-purple"><input data-all="false" id="color-blue-purple" name="color-blue-purple" type="checkbox" value="blue-purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-blue-purple"></span>
                                        <span className="ExpandablePanel__optionName">blue-purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="grey"><input data-all="false" id="color-grey" name="color-grey" type="checkbox" value="grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-grey"></span>
                                        <span className="ExpandablePanel__optionName">grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="metallic"><input data-all="false" id="color-metallic" name="color-metallic" type="checkbox" value="metallic"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-metallic"></span>
                                        <span className="ExpandablePanel__optionName">metallic</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="nude-tan"><input data-all="false" id="color-nude-tan" name="color-nude-tan" type="checkbox" value="nude-tan"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-nude-tan"></span>
                                        <span className="ExpandablePanel__optionName">nude-tan</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="white-ivory"><input data-all="false" id="color-white-ivory" name="color-white-ivory" type="checkbox" value="white-ivory"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-white-ivory"></span>
                                        <span className="ExpandablePanel__optionName">white-ivory</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="Cheetah"><input data-all="false" id="color-Cheetah" name="color-Cheetah" type="checkbox" value="Cheetah"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cheetah"></span>
                                        <span className="ExpandablePanel__optionName">Cheetah</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="Rosebud"><input data-all="false" id="color-Rosebud" name="color-Rosebud" type="checkbox" value="Rosebud"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-rosebud"></span>
                                        <span className="ExpandablePanel__optionName">Rosebud</span>
                                    </label>
                                </div>
                                <div className="ExpandablePanel__moreOptions">
                                    <a className="js-trigger-see-more" href="javascript:;">More Colors & Patterns</a>
                                </div>
                            </div>
                            <div className="ExpandablePanel__moreOptionsList">
                                <div className="ExpandablePanel__listOptions ExpandablePanel__listOptions--twoColumns ExpandablePanel__listOptions--panelColors">
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name=""><input data-all="false" id="color-" name="color-" type="checkbox" value=""/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-"></span>
                                        <span className="ExpandablePanel__optionName"></span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="Black-no-train"><input data-all="false" id="color-Black-no-train" name="color-Black-no-train" type="checkbox" value="Black-no-train"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-Black-no-train"></span>
                                        <span className="ExpandablePanel__optionName">Black-no-train</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="apple-green"><input data-all="false" id="color-apple-green" name="color-apple-green" type="checkbox" value="apple-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-apple-green"></span>
                                        <span className="ExpandablePanel__optionName">apple-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="apricot"><input data-all="false" id="color-apricot" name="color-apricot" type="checkbox" value="apricot"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-apricot"></span>
                                        <span className="ExpandablePanel__optionName">apricot</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="aqua"><input data-all="false" id="color-aqua" name="color-aqua" type="checkbox" value="aqua"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-aqua"></span>
                                        <span className="ExpandablePanel__optionName">aqua</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="aqua-lily"><input data-all="false" id="color-aqua-lily" name="color-aqua-lily" type="checkbox" value="aqua-lily"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-aqua-lily"></span>
                                        <span className="ExpandablePanel__optionName">aqua-lily</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="army-green"><input data-all="false" id="color-army-green" name="color-army-green" type="checkbox" value="army-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-army-green"></span>
                                        <span className="ExpandablePanel__optionName">army-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="art-soul"><input data-all="false" id="color-art-soul" name="color-art-soul" type="checkbox" value="art-soul"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-art-soul"></span>
                                        <span className="ExpandablePanel__optionName">art-soul</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="azure"><input data-all="false" id="color-azure" name="color-azure" type="checkbox" value="azure"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-azure"></span>
                                        <span className="ExpandablePanel__optionName">azure</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="baby-blue"><input data-all="false" id="color-baby-blue" name="color-baby-blue" type="checkbox" value="baby-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-baby-blue"></span>
                                        <span className="ExpandablePanel__optionName">baby-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="baby-pink"><input data-all="false" id="color-baby-pink" name="color-baby-pink" type="checkbox" value="baby-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-baby-pink"></span>
                                        <span className="ExpandablePanel__optionName">baby-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="back"><input data-all="false" id="color-back" name="color-back" type="checkbox" value="back"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-back"></span>
                                        <span className="ExpandablePanel__optionName">back</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ballerina"><input data-all="false" id="color-ballerina" name="color-ballerina" type="checkbox" value="ballerina"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ballerina"></span>
                                        <span className="ExpandablePanel__optionName">ballerina</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="beige"><input data-all="false" id="color-beige" name="color-beige" type="checkbox" value="beige"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-beige"></span>
                                        <span className="ExpandablePanel__optionName">beige</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="berry"><input data-all="false" id="color-berry" name="color-berry" type="checkbox" value="berry"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-berry"></span>
                                        <span className="ExpandablePanel__optionName">berry</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bird-of-paradise"><input data-all="false" id="color-bird-of-paradise" name="color-bird-of-paradise" type="checkbox" value="bird-of-paradise"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bird-of-paradise"></span>
                                        <span className="ExpandablePanel__optionName">bird-of-paradise</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black"><input data-all="false" id="color-black" name="color-black" type="checkbox" value="black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black"></span>
                                        <span className="ExpandablePanel__optionName">black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-chartreuse"><input data-all="false" id="color-black-and-chartreuse" name="color-black-and-chartreuse" type="checkbox" value="black-and-chartreuse"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-chartreuse"></span>
                                        <span className="ExpandablePanel__optionName">black-and-chartreuse</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-gold"><input data-all="false" id="color-black-and-gold" name="color-black-and-gold" type="checkbox" value="black-and-gold"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-gold"></span>
                                        <span className="ExpandablePanel__optionName">black-and-gold</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-hot-pink"><input data-all="false" id="color-black-and-hot-pink" name="color-black-and-hot-pink" type="checkbox" value="black-and-hot-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-hot-pink"></span>
                                        <span className="ExpandablePanel__optionName">black-and-hot-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-navy"><input data-all="false" id="color-black-and-navy" name="color-black-and-navy" type="checkbox" value="black-and-navy"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-navy"></span>
                                        <span className="ExpandablePanel__optionName">black-and-navy</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-peacock"><input data-all="false" id="color-black-and-peacock" name="color-black-and-peacock" type="checkbox" value="black-and-peacock"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-peacock"></span>
                                        <span className="ExpandablePanel__optionName">black-and-peacock</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-purple"><input data-all="false" id="color-black-and-purple" name="color-black-and-purple" type="checkbox" value="black-and-purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-purple"></span>
                                        <span className="ExpandablePanel__optionName">black-and-purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-red"><input data-all="false" id="color-black-and-red" name="color-black-and-red" type="checkbox" value="black-and-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-red"></span>
                                        <span className="ExpandablePanel__optionName">black-and-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-vintage-gold"><input data-all="false" id="color-black-and-vintage-gold" name="color-black-and-vintage-gold" type="checkbox" value="black-and-vintage-gold"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-vintage-gold"></span>
                                        <span className="ExpandablePanel__optionName">black-and-vintage-gold</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-and-white"><input data-all="false" id="color-black-and-white" name="color-black-and-white" type="checkbox" value="black-and-white"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-and-white"></span>
                                        <span className="ExpandablePanel__optionName">black-and-white</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="black-on-cream"><input data-all="false" id="color-black-on-cream" name="color-black-on-cream" type="checkbox" value="black-on-cream"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-black-on-cream"></span>
                                        <span className="ExpandablePanel__optionName">black-on-cream</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="blood-red"><input data-all="false" id="color-blood-red" name="color-blood-red" type="checkbox" value="blood-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-blood-red"></span>
                                        <span className="ExpandablePanel__optionName">blood-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="blue"><input data-all="false" id="color-blue" name="color-blue" type="checkbox" value="blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-blue"></span>
                                        <span className="ExpandablePanel__optionName">blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="blue-azalea-floral"><input data-all="false" id="color-blue-azalea-floral" name="color-blue-azalea-floral" type="checkbox" value="blue-azalea-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-blue-azalea-floral"></span>
                                        <span className="ExpandablePanel__optionName">blue-azalea-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="blue-fallen-leaves"><input data-all="false" id="color-blue-fallen-leaves" name="color-blue-fallen-leaves" type="checkbox" value="blue-fallen-leaves"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-blue-fallen-leaves"></span>
                                        <span className="ExpandablePanel__optionName">blue-fallen-leaves</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="blush"><input data-all="false" id="color-blush" name="color-blush" type="checkbox" value="blush"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-blush"></span>
                                        <span className="ExpandablePanel__optionName">blush</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="brick"><input data-all="false" id="color-brick" name="color-brick" type="checkbox" value="brick"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-brick"></span>
                                        <span className="ExpandablePanel__optionName">brick</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bright-blue"><input data-all="false" id="color-bright-blue" name="color-bright-blue" type="checkbox" value="bright-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bright-blue"></span>
                                        <span className="ExpandablePanel__optionName">bright-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bright-candy-pink"><input data-all="false" id="color-bright-candy-pink" name="color-bright-candy-pink" type="checkbox" value="bright-candy-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bright-candy-pink"></span>
                                        <span className="ExpandablePanel__optionName">bright-candy-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bright-lavender"><input data-all="false" id="color-bright-lavender" name="color-bright-lavender" type="checkbox" value="bright-lavender"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bright-lavender"></span>
                                        <span className="ExpandablePanel__optionName">bright-lavender</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bright-orange"><input data-all="false" id="color-bright-orange" name="color-bright-orange" type="checkbox" value="bright-orange"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bright-orange"></span>
                                        <span className="ExpandablePanel__optionName">bright-orange</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bright-red"><input data-all="false" id="color-bright-red" name="color-bright-red" type="checkbox" value="bright-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bright-red"></span>
                                        <span className="ExpandablePanel__optionName">bright-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bright-yellow"><input data-all="false" id="color-bright-yellow" name="color-bright-yellow" type="checkbox" value="bright-yellow"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bright-yellow"></span>
                                        <span className="ExpandablePanel__optionName">bright-yellow</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="bronze"><input data-all="false" id="color-bronze" name="color-bronze" type="checkbox" value="bronze"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-bronze"></span>
                                        <span className="ExpandablePanel__optionName">bronze</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="burgundy"><input data-all="false" id="color-burgundy" name="color-burgundy" type="checkbox" value="burgundy"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-burgundy"></span>
                                        <span className="ExpandablePanel__optionName">burgundy</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="burnt-orange"><input data-all="false" id="color-burnt-orange" name="color-burnt-orange" type="checkbox" value="burnt-orange"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-burnt-orange"></span>
                                        <span className="ExpandablePanel__optionName">burnt-orange</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="candy-pink"><input data-all="false" id="color-candy-pink" name="color-candy-pink" type="checkbox" value="candy-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-candy-pink"></span>
                                        <span className="ExpandablePanel__optionName">candy-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="casablanca"><input data-all="false" id="color-casablanca" name="color-casablanca" type="checkbox" value="casablanca"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-casablanca"></span>
                                        <span className="ExpandablePanel__optionName">casablanca</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="chambray"><input data-all="false" id="color-chambray" name="color-chambray" type="checkbox" value="chambray"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-chambray"></span>
                                        <span className="ExpandablePanel__optionName">chambray</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="champagne"><input data-all="false" id="color-champagne" name="color-champagne" type="checkbox" value="champagne"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-champagne"></span>
                                        <span className="ExpandablePanel__optionName">champagne</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="champaign"><input data-all="false" id="color-champaign" name="color-champaign" type="checkbox" value="champaign"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-champaign"></span>
                                        <span className="ExpandablePanel__optionName">champaign</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="charcoal"><input data-all="false" id="color-charcoal" name="color-charcoal" type="checkbox" value="charcoal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-charcoal"></span>
                                        <span className="ExpandablePanel__optionName">charcoal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="charteuse"><input data-all="false" id="color-charteuse" name="color-charteuse" type="checkbox" value="charteuse"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-charteuse"></span>
                                        <span className="ExpandablePanel__optionName">charteuse</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="chartreuse"><input data-all="false" id="color-chartreuse" name="color-chartreuse" type="checkbox" value="chartreuse"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-chartreuse"></span>
                                        <span className="ExpandablePanel__optionName">chartreuse</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cheetah"><input data-all="false" id="color-cheetah" name="color-cheetah" type="checkbox" value="cheetah"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cheetah"></span>
                                        <span className="ExpandablePanel__optionName">cheetah</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cherry-red"><input data-all="false" id="color-cherry-red" name="color-cherry-red" type="checkbox" value="cherry-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cherry-red"></span>
                                        <span className="ExpandablePanel__optionName">cherry-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="chocolate"><input data-all="false" id="color-chocolate" name="color-chocolate" type="checkbox" value="chocolate"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-chocolate"></span>
                                        <span className="ExpandablePanel__optionName">chocolate</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cobalt-blue"><input data-all="false" id="color-cobalt-blue" name="color-cobalt-blue" type="checkbox" value="cobalt-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cobalt-blue"></span>
                                        <span className="ExpandablePanel__optionName">cobalt-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cobalt-crush-floral"><input data-all="false" id="color-cobalt-crush-floral" name="color-cobalt-crush-floral" type="checkbox" value="cobalt-crush-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cobalt-crush-floral"></span>
                                        <span className="ExpandablePanel__optionName">cobalt-crush-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="coffe"><input data-all="false" id="color-coffe" name="color-coffe" type="checkbox" value="coffe"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-coffe"></span>
                                        <span className="ExpandablePanel__optionName">coffe</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="coffee"><input data-all="false" id="color-coffee" name="color-coffee" type="checkbox" value="coffee"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-coffee"></span>
                                        <span className="ExpandablePanel__optionName">coffee</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="coffeee"><input data-all="false" id="color-coffeee" name="color-coffeee" type="checkbox" value="coffeee"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-coffeee"></span>
                                        <span className="ExpandablePanel__optionName">coffeee</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="colbalt-crush-floral"><input data-all="false" id="color-colbalt-crush-floral" name="color-colbalt-crush-floral" type="checkbox" value="colbalt-crush-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-colbalt-crush-floral"></span>
                                        <span className="ExpandablePanel__optionName">colbalt-crush-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="coral"><input data-all="false" id="color-coral" name="color-coral" type="checkbox" value="coral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-coral"></span>
                                        <span className="ExpandablePanel__optionName">coral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cornflower-blue"><input data-all="false" id="color-cornflower-blue" name="color-cornflower-blue" type="checkbox" value="cornflower-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cornflower-blue"></span>
                                        <span className="ExpandablePanel__optionName">cornflower-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cotton-candy"><input data-all="false" id="color-cotton-candy" name="color-cotton-candy" type="checkbox" value="cotton-candy"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cotton-candy"></span>
                                        <span className="ExpandablePanel__optionName">cotton-candy</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cream"><input data-all="false" id="color-cream" name="color-cream" type="checkbox" value="cream"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cream"></span>
                                        <span className="ExpandablePanel__optionName">cream</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="cream-and-blue"><input data-all="false" id="color-cream-and-blue" name="color-cream-and-blue" type="checkbox" value="cream-and-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-cream-and-blue"></span>
                                        <span className="ExpandablePanel__optionName">cream-and-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="creme"><input data-all="false" id="color-creme" name="color-creme" type="checkbox" value="creme"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-creme"></span>
                                        <span className="ExpandablePanel__optionName">creme</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="crosswalk"><input data-all="false" id="color-crosswalk" name="color-crosswalk" type="checkbox" value="crosswalk"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-crosswalk"></span>
                                        <span className="ExpandablePanel__optionName">crosswalk</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-blue"><input data-all="false" id="color-dark-blue" name="color-dark-blue" type="checkbox" value="dark-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-blue"></span>
                                        <span className="ExpandablePanel__optionName">dark-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-burgundy"><input data-all="false" id="color-dark-burgundy" name="color-dark-burgundy" type="checkbox" value="dark-burgundy"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-burgundy"></span>
                                        <span className="ExpandablePanel__optionName">dark-burgundy</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-chocolate"><input data-all="false" id="color-dark-chocolate" name="color-dark-chocolate" type="checkbox" value="dark-chocolate"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-chocolate"></span>
                                        <span className="ExpandablePanel__optionName">dark-chocolate</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-forest"><input data-all="false" id="color-dark-forest" name="color-dark-forest" type="checkbox" value="dark-forest"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-forest"></span>
                                        <span className="ExpandablePanel__optionName">dark-forest</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-gold"><input data-all="false" id="color-dark-gold" name="color-dark-gold" type="checkbox" value="dark-gold"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-gold"></span>
                                        <span className="ExpandablePanel__optionName">dark-gold</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-grey"><input data-all="false" id="color-dark-grey" name="color-dark-grey" type="checkbox" value="dark-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-grey"></span>
                                        <span className="ExpandablePanel__optionName">dark-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-lavender"><input data-all="false" id="color-dark-lavender" name="color-dark-lavender" type="checkbox" value="dark-lavender"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-lavender"></span>
                                        <span className="ExpandablePanel__optionName">dark-lavender</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-mint"><input data-all="false" id="color-dark-mint" name="color-dark-mint" type="checkbox" value="dark-mint"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-mint"></span>
                                        <span className="ExpandablePanel__optionName">dark-mint</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-nude"><input data-all="false" id="color-dark-nude" name="color-dark-nude" type="checkbox" value="dark-nude"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-nude"></span>
                                        <span className="ExpandablePanel__optionName">dark-nude</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-purple"><input data-all="false" id="color-dark-purple" name="color-dark-purple" type="checkbox" value="dark-purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-purple"></span>
                                        <span className="ExpandablePanel__optionName">dark-purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-tan"><input data-all="false" id="color-dark-tan" name="color-dark-tan" type="checkbox" value="dark-tan"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-tan"></span>
                                        <span className="ExpandablePanel__optionName">dark-tan</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dark-teal"><input data-all="false" id="color-dark-teal" name="color-dark-teal" type="checkbox" value="dark-teal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dark-teal"></span>
                                        <span className="ExpandablePanel__optionName">dark-teal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="deep-purple"><input data-all="false" id="color-deep-purple" name="color-deep-purple" type="checkbox" value="deep-purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-deep-purple"></span>
                                        <span className="ExpandablePanel__optionName">deep-purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dusk"><input data-all="false" id="color-dusk" name="color-dusk" type="checkbox" value="dusk"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dusk"></span>
                                        <span className="ExpandablePanel__optionName">dusk</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dusty-mushroom"><input data-all="false" id="color-dusty-mushroom" name="color-dusty-mushroom" type="checkbox" value="dusty-mushroom"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dusty-mushroom"></span>
                                        <span className="ExpandablePanel__optionName">dusty-mushroom</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dusty-peach"><input data-all="false" id="color-dusty-peach" name="color-dusty-peach" type="checkbox" value="dusty-peach"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dusty-peach"></span>
                                        <span className="ExpandablePanel__optionName">dusty-peach</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="dusty-pink"><input data-all="false" id="color-dusty-pink" name="color-dusty-pink" type="checkbox" value="dusty-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-dusty-pink"></span>
                                        <span className="ExpandablePanel__optionName">dusty-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="electric-blue"><input data-all="false" id="color-electric-blue" name="color-electric-blue" type="checkbox" value="electric-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-electric-blue"></span>
                                        <span className="ExpandablePanel__optionName">electric-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="emerald"><input data-all="false" id="color-emerald" name="color-emerald" type="checkbox" value="emerald"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-emerald"></span>
                                        <span className="ExpandablePanel__optionName">emerald</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="emerald-green"><input data-all="false" id="color-emerald-green" name="color-emerald-green" type="checkbox" value="emerald-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-emerald-green"></span>
                                        <span className="ExpandablePanel__optionName">emerald-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="evening-bloom"><input data-all="false" id="color-evening-bloom" name="color-evening-bloom" type="checkbox" value="evening-bloom"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-evening-bloom"></span>
                                        <span className="ExpandablePanel__optionName">evening-bloom</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="feather-love"><input data-all="false" id="color-feather-love" name="color-feather-love" type="checkbox" value="feather-love"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-feather-love"></span>
                                        <span className="ExpandablePanel__optionName">feather-love</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="feather-lover"><input data-all="false" id="color-feather-lover" name="color-feather-lover" type="checkbox" value="feather-lover"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-feather-lover"></span>
                                        <span className="ExpandablePanel__optionName">feather-lover</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="firered"><input data-all="false" id="color-firered" name="color-firered" type="checkbox" value="firered"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-firered"></span>
                                        <span className="ExpandablePanel__optionName">firered</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="flamingo-pink"><input data-all="false" id="color-flamingo-pink" name="color-flamingo-pink" type="checkbox" value="flamingo-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-flamingo-pink"></span>
                                        <span className="ExpandablePanel__optionName">flamingo-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="fluoro-orange"><input data-all="false" id="color-fluoro-orange" name="color-fluoro-orange" type="checkbox" value="fluoro-orange"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-fluoro-orange"></span>
                                        <span className="ExpandablePanel__optionName">fluoro-orange</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="fluoro-yellow"><input data-all="false" id="color-fluoro-yellow" name="color-fluoro-yellow" type="checkbox" value="fluoro-yellow"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-fluoro-yellow"></span>
                                        <span className="ExpandablePanel__optionName">fluoro-yellow</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="forest-green"><input data-all="false" id="color-forest-green" name="color-forest-green" type="checkbox" value="forest-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-forest-green"></span>
                                        <span className="ExpandablePanel__optionName">forest-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="forrest-green"><input data-all="false" id="color-forrest-green" name="color-forrest-green" type="checkbox" value="forrest-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-forrest-green"></span>
                                        <span className="ExpandablePanel__optionName">forrest-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="fuchsia"><input data-all="false" id="color-fuchsia" name="color-fuchsia" type="checkbox" value="fuchsia"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-fuchsia"></span>
                                        <span className="ExpandablePanel__optionName">fuchsia</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="fuschia"><input data-all="false" id="color-fuschia" name="color-fuschia" type="checkbox" value="fuschia"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-fuschia"></span>
                                        <span className="ExpandablePanel__optionName">fuschia</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="garden-floral"><input data-all="false" id="color-garden-floral" name="color-garden-floral" type="checkbox" value="garden-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-garden-floral"></span>
                                        <span className="ExpandablePanel__optionName">garden-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="geo-sage"><input data-all="false" id="color-geo-sage" name="color-geo-sage" type="checkbox" value="geo-sage"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-geo-sage"></span>
                                        <span className="ExpandablePanel__optionName">geo-sage</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="gold"><input data-all="false" id="color-gold" name="color-gold" type="checkbox" value="gold"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-gold"></span>
                                        <span className="ExpandablePanel__optionName">gold</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="gold-shimmer"><input data-all="false" id="color-gold-shimmer" name="color-gold-shimmer" type="checkbox" value="gold-shimmer"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-gold-shimmer"></span>
                                        <span className="ExpandablePanel__optionName">gold-shimmer</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="grand-lily"><input data-all="false" id="color-grand-lily" name="color-grand-lily" type="checkbox" value="grand-lily"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-grand-lily"></span>
                                        <span className="ExpandablePanel__optionName">grand-lily</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="green"><input data-all="false" id="color-green" name="color-green" type="checkbox" value="green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-green"></span>
                                        <span className="ExpandablePanel__optionName">green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="green-shimmer"><input data-all="false" id="color-green-shimmer" name="color-green-shimmer" type="checkbox" value="green-shimmer"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-green-shimmer"></span>
                                        <span className="ExpandablePanel__optionName">green-shimmer</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="grey"><input data-all="false" id="color-grey" name="color-grey" type="checkbox" value="grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-grey"></span>
                                        <span className="ExpandablePanel__optionName">grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="grey-marle"><input data-all="false" id="color-grey-marle" name="color-grey-marle" type="checkbox" value="grey-marle"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-grey-marle"></span>
                                        <span className="ExpandablePanel__optionName">grey-marle</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="gunmetal"><input data-all="false" id="color-gunmetal" name="color-gunmetal" type="checkbox" value="gunmetal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-gunmetal"></span>
                                        <span className="ExpandablePanel__optionName">gunmetal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="gypsy-queen"><input data-all="false" id="color-gypsy-queen" name="color-gypsy-queen" type="checkbox" value="gypsy-queen"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-gypsy-queen"></span>
                                        <span className="ExpandablePanel__optionName">gypsy-queen</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="gypsy-scarf"><input data-all="false" id="color-gypsy-scarf" name="color-gypsy-scarf" type="checkbox" value="gypsy-scarf"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-gypsy-scarf"></span>
                                        <span className="ExpandablePanel__optionName">gypsy-scarf</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="horoscope"><input data-all="false" id="color-horoscope" name="color-horoscope" type="checkbox" value="horoscope"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-horoscope"></span>
                                        <span className="ExpandablePanel__optionName">horoscope</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="hot-pink"><input data-all="false" id="color-hot-pink" name="color-hot-pink" type="checkbox" value="hot-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-hot-pink"></span>
                                        <span className="ExpandablePanel__optionName">hot-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="hunter-green"><input data-all="false" id="color-hunter-green" name="color-hunter-green" type="checkbox" value="hunter-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-hunter-green"></span>
                                        <span className="ExpandablePanel__optionName">hunter-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ice-blue"><input data-all="false" id="color-ice-blue" name="color-ice-blue" type="checkbox" value="ice-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ice-blue"></span>
                                        <span className="ExpandablePanel__optionName">ice-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ice-grey"><input data-all="false" id="color-ice-grey" name="color-ice-grey" type="checkbox" value="ice-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ice-grey"></span>
                                        <span className="ExpandablePanel__optionName">ice-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="icing-pink-and-red"><input data-all="false" id="color-icing-pink-and-red" name="color-icing-pink-and-red" type="checkbox" value="icing-pink-and-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-icing-pink-and-red"></span>
                                        <span className="ExpandablePanel__optionName">icing-pink-and-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="indigo"><input data-all="false" id="color-indigo" name="color-indigo" type="checkbox" value="indigo"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-indigo"></span>
                                        <span className="ExpandablePanel__optionName">indigo</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="indigo-cotton-stripe"><input data-all="false" id="color-indigo-cotton-stripe" name="color-indigo-cotton-stripe" type="checkbox" value="indigo-cotton-stripe"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-indigo-cotton-stripe"></span>
                                        <span className="ExpandablePanel__optionName">indigo-cotton-stripe</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="indigo-stripe"><input data-all="false" id="color-indigo-stripe" name="color-indigo-stripe" type="checkbox" value="indigo-stripe"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-indigo-stripe"></span>
                                        <span className="ExpandablePanel__optionName">indigo-stripe</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory"><input data-all="false" id="color-ivory" name="color-ivory" type="checkbox" value="ivory"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory"></span>
                                        <span className="ExpandablePanel__optionName">ivory</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-black"><input data-all="false" id="color-ivory-and-black" name="color-ivory-and-black" type="checkbox" value="ivory-and-black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-black"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-hot-pink"><input data-all="false" id="color-ivory-and-hot-pink" name="color-ivory-and-hot-pink" type="checkbox" value="ivory-and-hot-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-hot-pink"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-hot-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-ice-blue"><input data-all="false" id="color-ivory-and-ice-blue" name="color-ivory-and-ice-blue" type="checkbox" value="ivory-and-ice-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-ice-blue"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-ice-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-light-pink"><input data-all="false" id="color-ivory-and-light-pink" name="color-ivory-and-light-pink" type="checkbox" value="ivory-and-light-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-light-pink"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-light-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-navy"><input data-all="false" id="color-ivory-and-navy" name="color-ivory-and-navy" type="checkbox" value="ivory-and-navy"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-navy"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-navy</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-pale-pink"><input data-all="false" id="color-ivory-and-pale-pink" name="color-ivory-and-pale-pink" type="checkbox" value="ivory-and-pale-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-pale-pink"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-pale-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-pink"><input data-all="false" id="color-ivory-and-pink" name="color-ivory-and-pink" type="checkbox" value="ivory-and-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-pink"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ivory-and-tan"><input data-all="false" id="color-ivory-and-tan" name="color-ivory-and-tan" type="checkbox" value="ivory-and-tan"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ivory-and-tan"></span>
                                        <span className="ExpandablePanel__optionName">ivory-and-tan</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lavendar"><input data-all="false" id="color-lavendar" name="color-lavendar" type="checkbox" value="lavendar"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lavendar"></span>
                                        <span className="ExpandablePanel__optionName">lavendar</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lavender"><input data-all="false" id="color-lavender" name="color-lavender" type="checkbox" value="lavender"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lavender"></span>
                                        <span className="ExpandablePanel__optionName">lavender</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lavender-grey"><input data-all="false" id="color-lavender-grey" name="color-lavender-grey" type="checkbox" value="lavender-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lavender-grey"></span>
                                        <span className="ExpandablePanel__optionName">lavender-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lemon"><input data-all="false" id="color-lemon" name="color-lemon" type="checkbox" value="lemon"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lemon"></span>
                                        <span className="ExpandablePanel__optionName">lemon</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lemon-sorbet"><input data-all="false" id="color-lemon-sorbet" name="color-lemon-sorbet" type="checkbox" value="lemon-sorbet"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lemon-sorbet"></span>
                                        <span className="ExpandablePanel__optionName">lemon-sorbet</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-blue"><input data-all="false" id="color-light-blue" name="color-light-blue" type="checkbox" value="light-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-blue"></span>
                                        <span className="ExpandablePanel__optionName">light-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-gold"><input data-all="false" id="color-light-gold" name="color-light-gold" type="checkbox" value="light-gold"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-gold"></span>
                                        <span className="ExpandablePanel__optionName">light-gold</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-khaki"><input data-all="false" id="color-light-khaki" name="color-light-khaki" type="checkbox" value="light-khaki"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-khaki"></span>
                                        <span className="ExpandablePanel__optionName">light-khaki</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-lavender"><input data-all="false" id="color-light-lavender" name="color-light-lavender" type="checkbox" value="light-lavender"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-lavender"></span>
                                        <span className="ExpandablePanel__optionName">light-lavender</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-nude"><input data-all="false" id="color-light-nude" name="color-light-nude" type="checkbox" value="light-nude"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-nude"></span>
                                        <span className="ExpandablePanel__optionName">light-nude</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-pink"><input data-all="false" id="color-light-pink" name="color-light-pink" type="checkbox" value="light-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-pink"></span>
                                        <span className="ExpandablePanel__optionName">light-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-pink-and-charcoal"><input data-all="false" id="color-light-pink-and-charcoal" name="color-light-pink-and-charcoal" type="checkbox" value="light-pink-and-charcoal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-pink-and-charcoal"></span>
                                        <span className="ExpandablePanel__optionName">light-pink-and-charcoal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="light-teal"><input data-all="false" id="color-light-teal" name="color-light-teal" type="checkbox" value="light-teal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-light-teal"></span>
                                        <span className="ExpandablePanel__optionName">light-teal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lilac"><input data-all="false" id="color-lilac" name="color-lilac" type="checkbox" value="lilac"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lilac"></span>
                                        <span className="ExpandablePanel__optionName">lilac</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lime-green"><input data-all="false" id="color-lime-green" name="color-lime-green" type="checkbox" value="lime-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lime-green"></span>
                                        <span className="ExpandablePanel__optionName">lime-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="lipstick-red"><input data-all="false" id="color-lipstick-red" name="color-lipstick-red" type="checkbox" value="lipstick-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-lipstick-red"></span>
                                        <span className="ExpandablePanel__optionName">lipstick-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="looking-glass"><input data-all="false" id="color-looking-glass" name="color-looking-glass" type="checkbox" value="looking-glass"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-looking-glass"></span>
                                        <span className="ExpandablePanel__optionName">looking-glass</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="magenta"><input data-all="false" id="color-magenta" name="color-magenta" type="checkbox" value="magenta"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-magenta"></span>
                                        <span className="ExpandablePanel__optionName">magenta</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="marine-blue"><input data-all="false" id="color-marine-blue" name="color-marine-blue" type="checkbox" value="marine-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-marine-blue"></span>
                                        <span className="ExpandablePanel__optionName">marine-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="mauve"><input data-all="false" id="color-mauve" name="color-mauve" type="checkbox" value="mauve"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-mauve"></span>
                                        <span className="ExpandablePanel__optionName">mauve</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="merlot"><input data-all="false" id="color-merlot" name="color-merlot" type="checkbox" value="merlot"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-merlot"></span>
                                        <span className="ExpandablePanel__optionName">merlot</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="metallic-peach"><input data-all="false" id="color-metallic-peach" name="color-metallic-peach" type="checkbox" value="metallic-peach"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-metallic-peach"></span>
                                        <span className="ExpandablePanel__optionName">metallic-peach</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="micro-spot"><input data-all="false" id="color-micro-spot" name="color-micro-spot" type="checkbox" value="micro-spot"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-micro-spot"></span>
                                        <span className="ExpandablePanel__optionName">micro-spot</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="micro-star"><input data-all="false" id="color-micro-star" name="color-micro-star" type="checkbox" value="micro-star"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-micro-star"></span>
                                        <span className="ExpandablePanel__optionName">micro-star</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="mid-blue"><input data-all="false" id="color-mid-blue" name="color-mid-blue" type="checkbox" value="mid-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-mid-blue"></span>
                                        <span className="ExpandablePanel__optionName">mid-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="mid-grey"><input data-all="false" id="color-mid-grey" name="color-mid-grey" type="checkbox" value="mid-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-mid-grey"></span>
                                        <span className="ExpandablePanel__optionName">mid-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="midnight-blue"><input data-all="false" id="color-midnight-blue" name="color-midnight-blue" type="checkbox" value="midnight-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-midnight-blue"></span>
                                        <span className="ExpandablePanel__optionName">midnight-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="midnight-floral"><input data-all="false" id="color-midnight-floral" name="color-midnight-floral" type="checkbox" value="midnight-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-midnight-floral"></span>
                                        <span className="ExpandablePanel__optionName">midnight-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="midnight-reptile"><input data-all="false" id="color-midnight-reptile" name="color-midnight-reptile" type="checkbox" value="midnight-reptile"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-midnight-reptile"></span>
                                        <span className="ExpandablePanel__optionName">midnight-reptile</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="mint"><input data-all="false" id="color-mint" name="color-mint" type="checkbox" value="mint"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-mint"></span>
                                        <span className="ExpandablePanel__optionName">mint</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="monochrome"><input data-all="false" id="color-monochrome" name="color-monochrome" type="checkbox" value="monochrome"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-monochrome"></span>
                                        <span className="ExpandablePanel__optionName">monochrome</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="monochrome-coda"><input data-all="false" id="color-monochrome-coda" name="color-monochrome-coda" type="checkbox" value="monochrome-coda"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-monochrome-coda"></span>
                                        <span className="ExpandablePanel__optionName">monochrome-coda</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="moonstone"><input data-all="false" id="color-moonstone" name="color-moonstone" type="checkbox" value="moonstone"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-moonstone"></span>
                                        <span className="ExpandablePanel__optionName">moonstone</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="morocco"><input data-all="false" id="color-morocco" name="color-morocco" type="checkbox" value="morocco"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-morocco"></span>
                                        <span className="ExpandablePanel__optionName">morocco</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="moss-green"><input data-all="false" id="color-moss-green" name="color-moss-green" type="checkbox" value="moss-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-moss-green"></span>
                                        <span className="ExpandablePanel__optionName">moss-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="mushroom"><input data-all="false" id="color-mushroom" name="color-mushroom" type="checkbox" value="mushroom"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-mushroom"></span>
                                        <span className="ExpandablePanel__optionName">mushroom</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="mustard"><input data-all="false" id="color-mustard" name="color-mustard" type="checkbox" value="mustard"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-mustard"></span>
                                        <span className="ExpandablePanel__optionName">mustard</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="nautical-stripe"><input data-all="false" id="color-nautical-stripe" name="color-nautical-stripe" type="checkbox" value="nautical-stripe"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-nautical-stripe"></span>
                                        <span className="ExpandablePanel__optionName">nautical-stripe</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="navy"><input data-all="false" id="color-navy" name="color-navy" type="checkbox" value="navy"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-navy"></span>
                                        <span className="ExpandablePanel__optionName">navy</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="navy-and-black"><input data-all="false" id="color-navy-and-black" name="color-navy-and-black" type="checkbox" value="navy-and-black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-navy-and-black"></span>
                                        <span className="ExpandablePanel__optionName">navy-and-black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="neon-mint"><input data-all="false" id="color-neon-mint" name="color-neon-mint" type="checkbox" value="neon-mint"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-neon-mint"></span>
                                        <span className="ExpandablePanel__optionName">neon-mint</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="neon-orange"><input data-all="false" id="color-neon-orange" name="color-neon-orange" type="checkbox" value="neon-orange"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-neon-orange"></span>
                                        <span className="ExpandablePanel__optionName">neon-orange</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="no-lining"><input data-all="false" id="color-no-lining" name="color-no-lining" type="checkbox" value="no-lining"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-no-lining"></span>
                                        <span className="ExpandablePanel__optionName">no-lining</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="nude"><input data-all="false" id="color-nude" name="color-nude" type="checkbox" value="nude"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-nude"></span>
                                        <span className="ExpandablePanel__optionName">nude</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="nude-and-black"><input data-all="false" id="color-nude-and-black" name="color-nude-and-black" type="checkbox" value="nude-and-black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-nude-and-black"></span>
                                        <span className="ExpandablePanel__optionName">nude-and-black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ocean"><input data-all="false" id="color-ocean" name="color-ocean" type="checkbox" value="ocean"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ocean"></span>
                                        <span className="ExpandablePanel__optionName">ocean</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ochre"><input data-all="false" id="color-ochre" name="color-ochre" type="checkbox" value="ochre"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ochre"></span>
                                        <span className="ExpandablePanel__optionName">ochre</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="off-white"><input data-all="false" id="color-off-white" name="color-off-white" type="checkbox" value="off-white"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-off-white"></span>
                                        <span className="ExpandablePanel__optionName">off-white</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="olive"><input data-all="false" id="color-olive" name="color-olive" type="checkbox" value="olive"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-olive"></span>
                                        <span className="ExpandablePanel__optionName">olive</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="olive-and-navy"><input data-all="false" id="color-olive-and-navy" name="color-olive-and-navy" type="checkbox" value="olive-and-navy"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-olive-and-navy"></span>
                                        <span className="ExpandablePanel__optionName">olive-and-navy</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="olive-shimmer"><input data-all="false" id="color-olive-shimmer" name="color-olive-shimmer" type="checkbox" value="olive-shimmer"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-olive-shimmer"></span>
                                        <span className="ExpandablePanel__optionName">olive-shimmer</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="oliver-shimmer"><input data-all="false" id="color-oliver-shimmer" name="color-oliver-shimmer" type="checkbox" value="oliver-shimmer"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-oliver-shimmer"></span>
                                        <span className="ExpandablePanel__optionName">oliver-shimmer</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="optic-white"><input data-all="false" id="color-optic-white" name="color-optic-white" type="checkbox" value="optic-white"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-optic-white"></span>
                                        <span className="ExpandablePanel__optionName">optic-white</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="orange"><input data-all="false" id="color-orange" name="color-orange" type="checkbox" value="orange"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-orange"></span>
                                        <span className="ExpandablePanel__optionName">orange</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="orange-and-hot-pink"><input data-all="false" id="color-orange-and-hot-pink" name="color-orange-and-hot-pink" type="checkbox" value="orange-and-hot-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-orange-and-hot-pink"></span>
                                        <span className="ExpandablePanel__optionName">orange-and-hot-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="orange-and-red"><input data-all="false" id="color-orange-and-red" name="color-orange-and-red" type="checkbox" value="orange-and-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-orange-and-red"></span>
                                        <span className="ExpandablePanel__optionName">orange-and-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ornate-midnight-floral"><input data-all="false" id="color-ornate-midnight-floral" name="color-ornate-midnight-floral" type="checkbox" value="ornate-midnight-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ornate-midnight-floral"></span>
                                        <span className="ExpandablePanel__optionName">ornate-midnight-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-blue"><input data-all="false" id="color-pale-blue" name="color-pale-blue" type="checkbox" value="pale-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-blue"></span>
                                        <span className="ExpandablePanel__optionName">pale-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-blue-cotton-stripe"><input data-all="false" id="color-pale-blue-cotton-stripe" name="color-pale-blue-cotton-stripe" type="checkbox" value="pale-blue-cotton-stripe"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-blue-cotton-stripe"></span>
                                        <span className="ExpandablePanel__optionName">pale-blue-cotton-stripe</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-blue-stripe"><input data-all="false" id="color-pale-blue-stripe" name="color-pale-blue-stripe" type="checkbox" value="pale-blue-stripe"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-blue-stripe"></span>
                                        <span className="ExpandablePanel__optionName">pale-blue-stripe</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-blush"><input data-all="false" id="color-pale-blush" name="color-pale-blush" type="checkbox" value="pale-blush"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-blush"></span>
                                        <span className="ExpandablePanel__optionName">pale-blush</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-green"><input data-all="false" id="color-pale-green" name="color-pale-green" type="checkbox" value="pale-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-green"></span>
                                        <span className="ExpandablePanel__optionName">pale-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-grey"><input data-all="false" id="color-pale-grey" name="color-pale-grey" type="checkbox" value="pale-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-grey"></span>
                                        <span className="ExpandablePanel__optionName">pale-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-lavender"><input data-all="false" id="color-pale-lavender" name="color-pale-lavender" type="checkbox" value="pale-lavender"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-lavender"></span>
                                        <span className="ExpandablePanel__optionName">pale-lavender</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-nude"><input data-all="false" id="color-pale-nude" name="color-pale-nude" type="checkbox" value="pale-nude"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-nude"></span>
                                        <span className="ExpandablePanel__optionName">pale-nude</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-pink"><input data-all="false" id="color-pale-pink" name="color-pale-pink" type="checkbox" value="pale-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-pink"></span>
                                        <span className="ExpandablePanel__optionName">pale-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-pink-and-pale-grey"><input data-all="false" id="color-pale-pink-and-pale-grey" name="color-pale-pink-and-pale-grey" type="checkbox" value="pale-pink-and-pale-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-pink-and-pale-grey"></span>
                                        <span className="ExpandablePanel__optionName">pale-pink-and-pale-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-silver"><input data-all="false" id="color-pale-silver" name="color-pale-silver" type="checkbox" value="pale-silver"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-silver"></span>
                                        <span className="ExpandablePanel__optionName">pale-silver</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-yellow"><input data-all="false" id="color-pale-yellow" name="color-pale-yellow" type="checkbox" value="pale-yellow"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-yellow"></span>
                                        <span className="ExpandablePanel__optionName">pale-yellow</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pale-yellow"><input data-all="false" id="color-pale-yellow" name="color-pale-yellow" type="checkbox" value="pale-yellow"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pale-yellow"></span>
                                        <span className="ExpandablePanel__optionName">pale-yellow</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="palermo-floral"><input data-all="false" id="color-palermo-floral" name="color-palermo-floral" type="checkbox" value="palermo-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-palermo-floral"></span>
                                        <span className="ExpandablePanel__optionName">palermo-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pastel-peach"><input data-all="false" id="color-pastel-peach" name="color-pastel-peach" type="checkbox" value="pastel-peach"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pastel-peach"></span>
                                        <span className="ExpandablePanel__optionName">pastel-peach</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pastel-pink"><input data-all="false" id="color-pastel-pink" name="color-pastel-pink" type="checkbox" value="pastel-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pastel-pink"></span>
                                        <span className="ExpandablePanel__optionName">pastel-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="peach"><input data-all="false" id="color-peach" name="color-peach" type="checkbox" value="peach"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-peach"></span>
                                        <span className="ExpandablePanel__optionName">peach</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="peacock"><input data-all="false" id="color-peacock" name="color-peacock" type="checkbox" value="peacock"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-peacock"></span>
                                        <span className="ExpandablePanel__optionName">peacock</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="persian-green"><input data-all="false" id="color-persian-green" name="color-persian-green" type="checkbox" value="persian-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-persian-green"></span>
                                        <span className="ExpandablePanel__optionName">persian-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="petal-pink"><input data-all="false" id="color-petal-pink" name="color-petal-pink" type="checkbox" value="petal-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-petal-pink"></span>
                                        <span className="ExpandablePanel__optionName">petal-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pine"><input data-all="false" id="color-pine" name="color-pine" type="checkbox" value="pine"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pine"></span>
                                        <span className="ExpandablePanel__optionName">pine</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink"><input data-all="false" id="color-pink" name="color-pink" type="checkbox" value="pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink"></span>
                                        <span className="ExpandablePanel__optionName">pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink-and-blush"><input data-all="false" id="color-pink-and-blush" name="color-pink-and-blush" type="checkbox" value="pink-and-blush"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink-and-blush"></span>
                                        <span className="ExpandablePanel__optionName">pink-and-blush</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink-and-rose"><input data-all="false" id="color-pink-and-rose" name="color-pink-and-rose" type="checkbox" value="pink-and-rose"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink-and-rose"></span>
                                        <span className="ExpandablePanel__optionName">pink-and-rose</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink-azalea-floral"><input data-all="false" id="color-pink-azalea-floral" name="color-pink-azalea-floral" type="checkbox" value="pink-azalea-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink-azalea-floral"></span>
                                        <span className="ExpandablePanel__optionName">pink-azalea-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink-azelea-floral"><input data-all="false" id="color-pink-azelea-floral" name="color-pink-azelea-floral" type="checkbox" value="pink-azelea-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink-azelea-floral"></span>
                                        <span className="ExpandablePanel__optionName">pink-azelea-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink-nouveau"><input data-all="false" id="color-pink-nouveau" name="color-pink-nouveau" type="checkbox" value="pink-nouveau"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink-nouveau"></span>
                                        <span className="ExpandablePanel__optionName">pink-nouveau</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink-red"><input data-all="false" id="color-pink-red" name="color-pink-red" type="checkbox" value="pink-red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink-red"></span>
                                        <span className="ExpandablePanel__optionName">pink-red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="pink-shimmer"><input data-all="false" id="color-pink-shimmer" name="color-pink-shimmer" type="checkbox" value="pink-shimmer"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-pink-shimmer"></span>
                                        <span className="ExpandablePanel__optionName">pink-shimmer</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="plum"><input data-all="false" id="color-plum" name="color-plum" type="checkbox" value="plum"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-plum"></span>
                                        <span className="ExpandablePanel__optionName">plum</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="polka-dot"><input data-all="false" id="color-polka-dot" name="color-polka-dot" type="checkbox" value="polka-dot"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-polka-dot"></span>
                                        <span className="ExpandablePanel__optionName">polka-dot</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="polka-dot"><input data-all="false" id="color-polka-dot" name="color-polka-dot" type="checkbox" value="polka-dot"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-polka-dot"></span>
                                        <span className="ExpandablePanel__optionName">polka-dot</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="purple"><input data-all="false" id="color-purple" name="color-purple" type="checkbox" value="purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-purple"></span>
                                        <span className="ExpandablePanel__optionName">purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="purple-metal"><input data-all="false" id="color-purple-metal" name="color-purple-metal" type="checkbox" value="purple-metal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-purple-metal"></span>
                                        <span className="ExpandablePanel__optionName">purple-metal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="red"><input data-all="false" id="color-red" name="color-red" type="checkbox" value="red"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-red"></span>
                                        <span className="ExpandablePanel__optionName">red</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="renta-watercolour"><input data-all="false" id="color-renta-watercolour" name="color-renta-watercolour" type="checkbox" value="renta-watercolour"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-renta-watercolour"></span>
                                        <span className="ExpandablePanel__optionName">renta-watercolour</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="rococo-floral"><input data-all="false" id="color-rococo-floral" name="color-rococo-floral" type="checkbox" value="rococo-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-rococo-floral"></span>
                                        <span className="ExpandablePanel__optionName">rococo-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="rose"><input data-all="false" id="color-rose" name="color-rose" type="checkbox" value="rose"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-rose"></span>
                                        <span className="ExpandablePanel__optionName">rose</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="rose-gold"><input data-all="false" id="color-rose-gold" name="color-rose-gold" type="checkbox" value="rose-gold"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-rose-gold"></span>
                                        <span className="ExpandablePanel__optionName">rose-gold</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="rosebud"><input data-all="false" id="color-rosebud" name="color-rosebud" type="checkbox" value="rosebud"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-rosebud"></span>
                                        <span className="ExpandablePanel__optionName">rosebud</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="rosewater-floral"><input data-all="false" id="color-rosewater-floral" name="color-rosewater-floral" type="checkbox" value="rosewater-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-rosewater-floral"></span>
                                        <span className="ExpandablePanel__optionName">rosewater-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="royal-blue"><input data-all="false" id="color-royal-blue" name="color-royal-blue" type="checkbox" value="royal-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-royal-blue"></span>
                                        <span className="ExpandablePanel__optionName">royal-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="royal-purple"><input data-all="false" id="color-royal-purple" name="color-royal-purple" type="checkbox" value="royal-purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-royal-purple"></span>
                                        <span className="ExpandablePanel__optionName">royal-purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="ruby"><input data-all="false" id="color-ruby" name="color-ruby" type="checkbox" value="ruby"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-ruby"></span>
                                        <span className="ExpandablePanel__optionName">ruby</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="sage"><input data-all="false" id="color-sage" name="color-sage" type="checkbox" value="sage"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-sage"></span>
                                        <span className="ExpandablePanel__optionName">sage</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="sage-fallen-leaves"><input data-all="false" id="color-sage-fallen-leaves" name="color-sage-fallen-leaves" type="checkbox" value="sage-fallen-leaves"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-sage-fallen-leaves"></span>
                                        <span className="ExpandablePanel__optionName">sage-fallen-leaves</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="sage-green"><input data-all="false" id="color-sage-green" name="color-sage-green" type="checkbox" value="sage-green"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-sage-green"></span>
                                        <span className="ExpandablePanel__optionName">sage-green</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="salmon"><input data-all="false" id="color-salmon" name="color-salmon" type="checkbox" value="salmon"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-salmon"></span>
                                        <span className="ExpandablePanel__optionName">salmon</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="sand"><input data-all="false" id="color-sand" name="color-sand" type="checkbox" value="sand"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-sand"></span>
                                        <span className="ExpandablePanel__optionName">sand</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="sea-foam"><input data-all="false" id="color-sea-foam" name="color-sea-foam" type="checkbox" value="sea-foam"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-sea-foam"></span>
                                        <span className="ExpandablePanel__optionName">sea-foam</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="shell"><input data-all="false" id="color-shell" name="color-shell" type="checkbox" value="shell"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-shell"></span>
                                        <span className="ExpandablePanel__optionName">shell</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver"><input data-all="false" id="color-silver" name="color-silver" type="checkbox" value="silver"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver"></span>
                                        <span className="ExpandablePanel__optionName">silver</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver-and-black"><input data-all="false" id="color-silver-and-black" name="color-silver-and-black" type="checkbox" value="silver-and-black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver-and-black"></span>
                                        <span className="ExpandablePanel__optionName">silver-and-black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver-and-ivory"><input data-all="false" id="color-silver-and-ivory" name="color-silver-and-ivory" type="checkbox" value="silver-and-ivory"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver-and-ivory"></span>
                                        <span className="ExpandablePanel__optionName">silver-and-ivory</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver-and-nude"><input data-all="false" id="color-silver-and-nude" name="color-silver-and-nude" type="checkbox" value="silver-and-nude"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver-and-nude"></span>
                                        <span className="ExpandablePanel__optionName">silver-and-nude</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver-and-pale-pink"><input data-all="false" id="color-silver-and-pale-pink" name="color-silver-and-pale-pink" type="checkbox" value="silver-and-pale-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver-and-pale-pink"></span>
                                        <span className="ExpandablePanel__optionName">silver-and-pale-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver-metallic-w/black-lining"><input data-all="false" id="color-silver-metallic-w_black-lining" name="color-silver-metallic-w/black-lining" type="checkbox" value="silver-metallic-w/black-lining"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver-metallic-w/black-lining"></span>
                                        <span className="ExpandablePanel__optionName">silver-metallic-w/black-lining</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver-metallic-w/nude-lining"><input data-all="false" id="color-silver-metallic-w_nude-lining" name="color-silver-metallic-w/nude-lining" type="checkbox" value="silver-metallic-w/nude-lining"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver-metallic-w/nude-lining"></span>
                                        <span className="ExpandablePanel__optionName">silver-metallic-w/nude-lining</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="silver-shimmer"><input data-all="false" id="color-silver-shimmer" name="color-silver-shimmer" type="checkbox" value="silver-shimmer"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-silver-shimmer"></span>
                                        <span className="ExpandablePanel__optionName">silver-shimmer</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="sky-blue"><input data-all="false" id="color-sky-blue" name="color-sky-blue" type="checkbox" value="sky-blue"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-sky-blue"></span>
                                        <span className="ExpandablePanel__optionName">sky-blue</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="socialite"><input data-all="false" id="color-socialite" name="color-socialite" type="checkbox" value="socialite"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-socialite"></span>
                                        <span className="ExpandablePanel__optionName">socialite</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="spot"><input data-all="false" id="color-spot" name="color-spot" type="checkbox" value="spot"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-spot"></span>
                                        <span className="ExpandablePanel__optionName">spot</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="steel"><input data-all="false" id="color-steel" name="color-steel" type="checkbox" value="steel"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-steel"></span>
                                        <span className="ExpandablePanel__optionName">steel</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="stone"><input data-all="false" id="color-stone" name="color-stone" type="checkbox" value="stone"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-stone"></span>
                                        <span className="ExpandablePanel__optionName">stone</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="sunset-orange"><input data-all="false" id="color-sunset-orange" name="color-sunset-orange" type="checkbox" value="sunset-orange"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-sunset-orange"></span>
                                        <span className="ExpandablePanel__optionName">sunset-orange</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="surreal-floral-black"><input data-all="false" id="color-surreal-floral-black" name="color-surreal-floral-black" type="checkbox" value="surreal-floral-black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-surreal-floral-black"></span>
                                        <span className="ExpandablePanel__optionName">surreal-floral-black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="surreal-floral-white"><input data-all="false" id="color-surreal-floral-white" name="color-surreal-floral-white" type="checkbox" value="surreal-floral-white"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-surreal-floral-white"></span>
                                        <span className="ExpandablePanel__optionName">surreal-floral-white</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="taffeta-monochrome"><input data-all="false" id="color-taffeta-monochrome" name="color-taffeta-monochrome" type="checkbox" value="taffeta-monochrome"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-taffeta-monochrome"></span>
                                        <span className="ExpandablePanel__optionName">taffeta-monochrome</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="tan"><input data-all="false" id="color-tan" name="color-tan" type="checkbox" value="tan"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-tan"></span>
                                        <span className="ExpandablePanel__optionName">tan</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="taupe"><input data-all="false" id="color-taupe" name="color-taupe" type="checkbox" value="taupe"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-taupe"></span>
                                        <span className="ExpandablePanel__optionName">taupe</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="teal"><input data-all="false" id="color-teal" name="color-teal" type="checkbox" value="teal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-teal"></span>
                                        <span className="ExpandablePanel__optionName">teal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="tribal"><input data-all="false" id="color-tribal" name="color-tribal" type="checkbox" value="tribal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-tribal"></span>
                                        <span className="ExpandablePanel__optionName">tribal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="tribal"><input data-all="false" id="color-tribal" name="color-tribal" type="checkbox" value="tribal"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-tribal"></span>
                                        <span className="ExpandablePanel__optionName">tribal</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="tribal-love"><input data-all="false" id="color-tribal-love" name="color-tribal-love" type="checkbox" value="tribal-love"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-tribal-love"></span>
                                        <span className="ExpandablePanel__optionName">tribal-love</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="tropical-floral"><input data-all="false" id="color-tropical-floral" name="color-tropical-floral" type="checkbox" value="tropical-floral"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-tropical-floral"></span>
                                        <span className="ExpandablePanel__optionName">tropical-floral</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="turquoise"><input data-all="false" id="color-turquoise" name="color-turquoise" type="checkbox" value="turquoise"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-turquoise"></span>
                                        <span className="ExpandablePanel__optionName">turquoise</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="vibrant-pink"><input data-all="false" id="color-vibrant-pink" name="color-vibrant-pink" type="checkbox" value="vibrant-pink"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-vibrant-pink"></span>
                                        <span className="ExpandablePanel__optionName">vibrant-pink</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="vibrant-purple"><input data-all="false" id="color-vibrant-purple" name="color-vibrant-purple" type="checkbox" value="vibrant-purple"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-vibrant-purple"></span>
                                        <span className="ExpandablePanel__optionName">vibrant-purple</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="warm-grey"><input data-all="false" id="color-warm-grey" name="color-warm-grey" type="checkbox" value="warm-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-warm-grey"></span>
                                        <span className="ExpandablePanel__optionName">warm-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="warm-olive"><input data-all="false" id="color-warm-olive" name="color-warm-olive" type="checkbox" value="warm-olive"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-warm-olive"></span>
                                        <span className="ExpandablePanel__optionName">warm-olive</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="water-grey"><input data-all="false" id="color-water-grey" name="color-water-grey" type="checkbox" value="water-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-water-grey"></span>
                                        <span className="ExpandablePanel__optionName">water-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="watercolour"><input data-all="false" id="color-watercolour" name="color-watercolour" type="checkbox" value="watercolour"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-watercolour"></span>
                                        <span className="ExpandablePanel__optionName">watercolour</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="watercolour-camo"><input data-all="false" id="color-watercolour-camo" name="color-watercolour-camo" type="checkbox" value="watercolour-camo"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-watercolour-camo"></span>
                                        <span className="ExpandablePanel__optionName">watercolour-camo</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="watermelon"><input data-all="false" id="color-watermelon" name="color-watermelon" type="checkbox" value="watermelon"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-watermelon"></span>
                                        <span className="ExpandablePanel__optionName">watermelon</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="white"><input data-all="false" id="color-white" name="color-white" type="checkbox" value="white"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-white"></span>
                                        <span className="ExpandablePanel__optionName">white</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="white-and-black"><input data-all="false" id="color-white-and-black" name="color-white-and-black" type="checkbox" value="white-and-black"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-white-and-black"></span>
                                        <span className="ExpandablePanel__optionName">white-and-black</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="white-and-mint"><input data-all="false" id="color-white-and-mint" name="color-white-and-mint" type="checkbox" value="white-and-mint"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-white-and-mint"></span>
                                        <span className="ExpandablePanel__optionName">white-and-mint</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="wine"><input data-all="false" id="color-wine" name="color-wine" type="checkbox" value="wine"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-wine"></span>
                                        <span className="ExpandablePanel__optionName">wine</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="winter-grey"><input data-all="false" id="color-winter-grey" name="color-winter-grey" type="checkbox" value="winter-grey"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-winter-grey"></span>
                                        <span className="ExpandablePanel__optionName">winter-grey</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="yellow"><input data-all="false" id="color-yellow" name="color-yellow" type="checkbox" value="yellow"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-yellow"></span>
                                        <span className="ExpandablePanel__optionName">yellow</span>
                                    </label>
                                    <label className="ExpandablePanel__option ExpandablePanel__listColumn" name="zebra"><input data-all="false" id="color-zebra" name="color-zebra" type="checkbox" value="zebra"/>
                                        <span className="ExpandablePanel__optionColorFallback"></span>
                                        <span className="ExpandablePanel__optionCheck--rounded ExpandablePanel__optionCheck--tick color-zebra"></span>
                                        <span className="ExpandablePanel__optionName">zebra</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div className="ExpandablePanelItem ExpandablePanelItem--is-active">
                            <div className="ExpandablePanel__name">
                                Price
                            </div>
                            <div className="ExpandablePanel__selectedOptions">
                                <span className="ExpandablePanel__selectedItem">$0 - 199</span>
                                <span className="ExpandablePanel__selectedItem">$200 - $299</span>
                            </div>
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                                <label className="ExpandablePanel__option" name="price"><input checked="checked" className="js-filter-all" data-all="true" id="price-all" name="price-all" type="checkbox" value="all"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">All prices</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="price"><input data-all="false" data-pricemax="199" data-pricemin="0" id="price-0-199" name="price" type="checkbox" value="0"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">$0 - $199</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="price"><input data-all="false" data-pricemax="299" data-pricemin="200" id="price-200-299" name="price" type="checkbox" value="200"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">$200 - $299</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="price"><input data-all="false" data-pricemax="399" data-pricemin="300" id="price-300-399" name="price" type="checkbox" value="300"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">$300 - $399</span>
                                    </span>
                                </label>
                            </div>
                        </div>
                        <div className="ExpandablePanelItem ExpandablePanelItem--is-active">
                            <div className="ExpandablePanel__name">
                                Bodyshape
                            </div>
                            <div className="ExpandablePanel__listOptions checkboxBlackBg">
                                <label className="ExpandablePanel__option" name="bodyshape"><input checked="checked" className="js-filter-all" data-all="true" id="shapes-all" name="shapes-all" type="checkbox" value="all"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">All shapes</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-apple" name="shape-apple" type="checkbox" value="apple"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">apple</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-athletic" name="shape-athletic" type="checkbox" value="athletic"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">athletic</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-column" name="shape-column" type="checkbox" value="column"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">column</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-hour_glass" name="shape-hour_glass" type="checkbox" value="hour_glass"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">hour glass</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-pear" name="shape-pear" type="checkbox" value="pear"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">pear</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-petite" name="shape-petite" type="checkbox" value="petite"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">petite</span>
                                    </span>
                                </label>
                                <label className="ExpandablePanel__option" name="shape"><input data-all="false" id="shape-strawberry" name="shape-strawberry" type="checkbox" value="strawberry"/>
                                    <span className="checkboxBlackBg__check">
                                        <span className="ExpandablePanel__optionName">strawberry</span>
                                    </span>
                                </label>
                            </div>
                        </div>
                        <div className="ExpandablePanel__secondaryFiltersWrapper">
                            <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
                                <div className="ExpandablePanel__name">
                                    Secondary Filter 1
                                </div>
                            </div>
                            <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
                                <div className="ExpandablePanel__name">
                                    Secondary Filter 2
                                </div>
                            </div>
                            <div className="ExpandablePanelItem ExpandablePanelItem--secondary">
                                <div className="ExpandablePanel__name">
                                    Secondary Filter 3aaaaa
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}

CollectionFilterSort.propTypes = {
    breakpoint: PropTypes.string,
    dispatch: PropTypes.func.isRequired,
    CollectionFilterSortState: PropTypes.object
};

export default Resize(breakpoints)(connect(stateToProps)(CollectionFilterSort));
