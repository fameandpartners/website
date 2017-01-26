var CombinationsMap = (function(){
  // This map is just a representation of the spreadsheet given with the
  // forbidden combinations of customizations.

  // This is a function called every time a user selects a customization
  // logic is pretty simple, a big map with true values for options that have to
  // be disabled.

  // Depending of which type customization we're dealing with, it's the position
  // where we'll place the name of that customization on the big map,
  // this customization value comes in the option argument of the function.

  // the map(json object) is 4 levels deep
  // level 1 is for silhouettes accessed using product sky
  // level 2 is fits accessed using customisation value name
  // level 3 is for styles accessed using customisation value name
  // level 4 is for lengths accessed using customisation value name


  var disabledMap = {
    FP2212: {
      F0: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F1: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F2: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F3: {
        S0: { MN: true, KN: true, PT: true },
        S1: { MN: true, KN: true, PT: true },
        S2: { MN: true, KN: true, PT: true },
        S3: { MN: true, KN: true, PT: true },
        S4: { MN: true, KN: true, PT: true },
        S5: { MN: true, KN: true, PT: true }
      },
      F4: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F5: {
        S0: { MN: true, KN: true, PT: true, MD: true },
        S1: { MN: true, KN: true, PT: true, MD: true },
        S2: { MN: true, KN: true, PT: true, MD: true },
        S3: { MN: true, KN: true, PT: true, MD: true },
        S4: { MN: true, KN: true, PT: true, MD: true },
        S5: { MN: true, KN: true, PT: true, MD: true }
      },
    },
    FP2213: {
      F0: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F1: {
        S0: {},
        S1: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: {},
        S5: {}
      },
      F2: {
        S0: {},
        S1: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S5: {}
      },
      F3: {
        S0: {},
        S1: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: {},
        S5: {}
      },
      F4: {
        S0: {},
        S1: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: {},
        S4: {},
        S5: {}
      },
      F5: {
        S0: { MN: true, KN: true, PT: true, MD: true },
        S1: { MN: true, KN: true, PT: true, MD: true },
        S2: { MN: true, KN: true, PT: true, MD: true },
        S3: { MN: true, KN: true, PT: true, MD: true },
        S4: { MN: true, KN: true, PT: true, MD: true },
        S5: { MN: true, KN: true, PT: true, MD: true }
      },
    },
    FP2214: {
      F0: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F1: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F2: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F3: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F4: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F5: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
    },
    FP2215: {
      F0: {
        S0: {},
        S1: { MN: true },
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F1: {
        S0: {},
        S1: { MN: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: {},
        S5: {}
      },
      F2: {
        S0: {},
        S1: { MN: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: {},
        S5: {}
      },
      F3: {
        S0: {},
        S1: { MN: true },
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F4: {
        S0: {},
        S1: { MN: true },
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F5: {
        S0: {},
        S1: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
    },
    FP2216: {
      F0: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F1: {
        S0: {},
        S1: {},
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: {},
        S5: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
      },
      F2: {
        S0: { MN: true },
        S1: { MN: true },
        S2: { MN: true },
        S3: { MN: true },
        S4: { MN: true },
        S5: { MN: true }
      },
      F3: {
        S0: {},
        S1: {},
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: {},
        S4: {},
        S5: {}
      },
      F4: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F5: {
        S0: { MN: true, KN: true, PT: true },
        S1: { MN: true, KN: true, PT: true },
        S2: { MN: true, KN: true, PT: true },
        S3: { MN: true, KN: true, PT: true },
        S4: { MN: true, KN: true, PT: true },
        S5: { MN: true, KN: true, PT: true }
      },
    },
    FP2218: {
      F0: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F1: {
        S0: { MN: true },
        S1: { MN: true },
        S2: { MN: true },
        S3: { MN: true },
        S4: { MN: true },
        S5: { MN: true }
      },
      F2: {
        S0: {},
        S1: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: {},
        S4: {},
        S5: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
      },
      F3: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F4: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F5: {
        S0: {},
        S1: { MN: true, KN: true, PT: true, MD: true },
        S2: { MN: true, KN: true, PT: true, MD: true },
        S3: {},
        S4: { MN: true, KN: true, PT: true, MD: true },
        S5: { MN: true, KN: true, PT: true, MD: true }
      },
    },
    FP2219: {
      F0: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F1: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F2: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F3: {
        S0: { MN: true, KN: true, PT: true },
        S1: { MN: true, KN: true, PT: true },
        S2: { MN: true, KN: true, PT: true },
        S3: { MN: true, KN: true, PT: true },
        S4: { MN: true, KN: true, PT: true },
        S5: { MN: true, KN: true, PT: true }
      },
      F4: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F5: {
        S0: { MN: true, KN: true, PT: true, MD: true },
        S1: { MN: true, KN: true, PT: true, MD: true },
        S2: { MN: true, KN: true, PT: true, MD: true },
        S3: { MN: true, KN: true, PT: true, MD: true },
        S4: { MN: true, KN: true, PT: true, MD: true },
        S5: { MN: true, KN: true, PT: true, MD: true }
      },
    },
    FP2220: {
      F0: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F1: {
        S0: { MX: true },
        S1: { MX: true },
        S2: { MX: true },
        S3: { MX: true },
        S4: { MX: true },
        S5: { MX: true }
      },
      F2: {
        S0: {},
        S1: {},
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: {},
        S4: {},
        S5: {}
      },
      F3: {
        S0: {},
        S1: {},
        S2: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S3: {},
        S4: {},
        S5: {}
      },
      F4: {
        S0: {},
        S1: {},
        S2: {},
        S3: {},
        S4: {},
        S5: {}
      },
      F5: {
        S0: { MN: true, KN: true, PT: true },
        S1: { MN: true, KN: true, PT: true },
        S2: { MN: true, KN: true, PT: true },
        S3: { MN: true, KN: true, PT: true },
        S4: { MN: true, KN: true, PT: true, MD: true, AK: true, MX: true },
        S5: { MN: true, KN: true, PT: true }
      },
    },
  }


  return {
    /**
      * returns true if the customization should be disabled
      * @param { object } optionsKeys
      * @param { object } customization
      * @param { string } type
    **/
    isDisabled: function(type, option, silhouetteKey, fitKey, styleKey, lengthKey){
      var silhouette = disabledMap[silhouetteKey];
      if(type == 'fit'){
        return silhouette[option.name][styleKey][lengthKey];
      }

      if(type == 'style') {
        return silhouette[fitKey][option.name][lengthKey];
      }

      if(type == 'length') {
        return silhouette[fitKey][styleKey][option.name];
      }
    }
  }
})();
