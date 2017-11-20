/* eslint-disable */

import React from "react";
import { render } from "react-dom";
import ShoppingSpree from "./ShoppingSpree";
import Cookies from "universal-cookie";

const cookies = new Cookies();

render(
  <ShoppingSpree
    firebaseAPI={window.ShoppingSpreeData.firebaseAPI}
    firebaseDatabase={window.ShoppingSpreeData.firebaseDatabase}
  />,

  document.getElementById("shopping-spree"),
);
