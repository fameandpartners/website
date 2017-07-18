import React, {Component} from 'react';
import ProductContainer from '../containers/ProductContainer'
import {Link} from 'react-router'
import Button from './Button'

class Confirmation extends Component {
  constructor(props) {
    super(props)
    const {returnArray}= props
    this.state = {
    	returnArray: returnArray
    }
  }
  render() {
  	const {returnArray} = this.state
  	if(returnArray) {
	  	return (
	  		<div className="instructions__container">
		  		<Link to="/" className="orders-link">Back to Orders</Link>
		  		<div className="instructions__body">
		  			 <p className="headline">
		 				We have emailed you your label and instructions <br/>
		 				Return your items by MM/DD/YYYY
	  		        </p>
	  		        <ul className="label-list hide-for-mobile">
	  		        	<li>
	  		        		<a href="#">Print Label</a>
	  		        	</li>
	  		        	<li>
	  		        		<a href="#">Email Label</a>
	  		        	</li>
	  		        </ul>
			  		<hr className="hide-for-mobile" />
			  		<div>
			  			<p className="list-title">
			  				Instructions for mailing your package
			  			</p>
			  			<ul className="list">
			  				<li>
			  					<p className="list-text">
			  						Print and cut out the shipping label
			  					</p>
			  				</li>
			  				<li>
			  					<p className="list-text">
			  						Make sure there are no barcodes or other tracking numbers on your package
			  					</p>
			  				</li>
			  				<li>
			  					<p className="list-text">
			  						Securely affix this label to your package.
			  					</p>
			  				</li>
			  				<li>
			  					<p className="list-text">
			  						Take to the nearest US post office for drop off. <a href="#" className="link">Locate nearest post office</a>
			  					</p>
			  				</li>
			  			</ul>
			  			<img src="http://placehold.it/610x410?text=Shipping Label" 
			  				 alt="Shipping Label" 
			  				 className="shipping-label hide-for-mobile"
			  			/>
			  			<p className="list-title">
			  				Packing Slip
			  			</p>
			  			<ul className="list">
			  				<li>
			  					<p className="list-text">Print and cut out the packing slip</p>
			  				</li>
			  				<li>
			  					<p className="list-text">Include inside your return package</p>
			  				</li>
			  			</ul>
			  		</div>
			  		<hr />
			  		
	  				<div>
	  					<p>Order #1231</p>
	  					{returnArray.map(p => {
	  					  const {productOrderID} = p
	  					  return <ProductContainer confirmationPage={true} key={productOrderID} product={p} />
	  					})}
	  				</div>
					<div className="button__container">
						<Button primary noMargin>
							<Link className="u-white-text button-link" to="/">Continue Shopping</Link>
						</Button>
					</div>
	  			</div>
	  		</div>
		  		
  		)
  	}
  	else {
  		return <div></div>
  	}
  }
}

export default Confirmation;