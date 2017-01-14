var CombinationsMap = (function(){
  var disabledMap = {
    FP2212: {
      disabledFits: {
        S3: { F1: true },
        S2: { F2: true }
      },
      disabledStyles: {
        F1: { S3: true },
        F2: { S2: true }
      },
      disabledLengths: {
        F0: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F1: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F2: {
          S0:{ MX: true },
          S1:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F3: {
          S0:{ MN: true, KN: true, PT: true },
          S1:{ MN: true, KN: true, PT: true },
          S2:{ MN: true, KN: true, PT: true },
          S3:{ MN: true, KN: true, PT: true },
          S4:{ MN: true, KN: true, PT: true },
          S5:{ MN: true, KN: true, PT: true }
        },
        F4: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F5: {
          S0:{ MN: true, KN: true, PT: true, MD: true },
          S1:{ MN: true, KN: true, PT: true, MD: true },
          S2:{ MN: true, KN: true, PT: true, MD: true },
          S3:{ MN: true, KN: true, PT: true, MD: true },
          S4:{ MN: true, KN: true, PT: true, MD: true },
          S5:{ MN: true, KN: true, PT: true, MD: true }
        }
      }
    },
    FP2213: {
      disabledFits: {
        S1: { F1: true, F2: true, F3: true, F4: true },
        S2: { F1: true, F2: true, F3: true, F4: true },
        S3: { F1: true, F2: true, F3: true },
        S4: { F2: true }
      },
      disabledStyles: {
        F1: { S1: true, S2: true, S3: true },
        F2: { S1: true, S2: true, S3: true, S4: true },
        F3: { S1: true, S2: true, S3: true },
        F4: { S1: true, S2: true },
      },
      disabledLengths: {
        F5: {
          S0:{ MN: true, KN: true, PT: true, MD: true },
          S1:{ MN: true, KN: true, PT: true, MD: true },
          S2:{ MN: true, KN: true, PT: true, MD: true },
          S3:{ MN: true, KN: true, PT: true, MD: true },
          S4:{ MN: true, KN: true, PT: true, MD: true },
          S5:{ MN: true, KN: true, PT: true, MD: true }
        }
      }
    },
    FP2214: {
      disabledFits: {
        S3: { F1: true, F2: true, F3: true }
      },
      disabledStyles: {
        F1: { S3: true },
        F2: { S3: true },
        F3: { S3: true }
      },
      disabledLengths: {
        F0: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F1: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F2: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F3: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F4: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        }
      }
    },
    FP2215: {
      disabledFits: {
        S1: { F5: true },
        S2: { F1: true, F2: true },
        S3: { F1: true, F2: true }
      },
      disabledStyles: {
        F1: { S2: true, S3: true },
        F2: { S2: true, S3: true },
        F5: { S1: true }
      },
      disabledLengths: {
        F0: {
          S1:{ MN: true }
        },
        F1: {
          S1:{ MN: true }
        },
        F2: {
          S1:{ MN: true }
        },
        F3: {
          S1:{ MN: true }
        },
        F4: {
          S1:{ MN: true }
        }
      }
    },
    FP2216: {
      disabledFits: {
        S2: { F1: true, F3: true },
        S3: { F1: true },
        S5: { F1: true },
      },
      disabledStyles: {
        F1: { S2: true, S3: true, F5: true },
        F3: { S2: true }
      },
      disabledLengths: {
        F2: {
          S0:{ MN: true },
          S1:{ MN: true },
          S3:{ MN: true },
          S4:{ MN: true },
          S5:{ MN: true }
        },
        F5: {
          S0:{ MN: true, KN: true, PT: true },
          S1:{ MN: true, KN: true, PT: true },
          S2:{ MN: true, KN: true, PT: true },
          S3:{ MN: true, KN: true, PT: true },
          S4:{ MN: true, KN: true, PT: true },
          S5:{ MN: true, KN: true, PT: true }
        }
      }
    },
    FP2218: {
      disabledFits: {
        S1: { F2: true, F5: true },
        S2: { F2: true, F5: true },
        S4: { F5: true },
        S5: { F2: true, F5: true }
      },
      disabledStyles: {
        F2: { S1: true, S2: true, S5: true },
        F5: { S1: true, S2: true, S4:true, S5: true }
      },
      disabledLengths: {
        F1: {
          S0:{ MN: true },
          S1:{ MN: true },
          S2:{ MN: true },
          S4:{ MN: true },
          S5:{ MN: true }
        },
        F4: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        }
      }
    },
    FP2219: {
      disabledFits: {
        S1: { F1: true, F2: true, F3: true, F5: true },
        S4: { F5: true },
        S5: { F5: true },
      },
      disabledStyles: {
        F1: { S1: true },
        F2: { S1: true },
        F3: { S1: true },
        F5: { S1: true, S4: true, S5: true }
      },
      disabledLengths: {
        F0: {
          S5: { MN: true, KN: true, PT: true, MD: true, AK: true }
        },
        F1: {
          S5: { MN: true, KN: true, PT: true, MD: true, AK: true }
        },
        F2: {
          S5: { MN: true, KN: true, PT: true, MD: true, AK: true }
        },
        F3: {
          S0: { MN: true, KN: true, PT: true, MD: true },
          S2: { MN: true, KN: true, PT: true, MD: true },
          S3: { MN: true, KN: true, PT: true, MD: true },
          S4: { MN: true, KN: true, PT: true, MD: true },
          S5: { MN: true, KN: true, PT: true, MD: true, AK: true }
        },
        F4: {
          S5: { MN: true, KN: true, PT: true, MD: true, AK: true }
        },
        F5: {
          S0: { MX: true },
          S2: { MX: true },
          S3: { MX: true }
        }
      }
    },
    FP2220: {
      disabledFits: {
        S2: { F2: true, F3: true },
        S4: { F5: true }
      },
      disabledStyles: {
        F2: { S2: true },
        F3: { S2: true },
        F5: { S4: true }
      },
      disabledLengths: {
        F1: {
          S0:{ MX: true },
          S1:{ MX: true },
          S2:{ MX: true },
          S3:{ MX: true },
          S4:{ MX: true },
          S5:{ MX: true }
        },
        F5: {
          S0:{ MN: true, KN: true, PT: true },
          S1:{ MN: true, KN: true, PT: true },
          S2:{ MN: true, KN: true, PT: true },
          S3:{ MN: true, KN: true, PT: true },
          S5:{ MN: true, KN: true, PT: true }
        }
      }
    },
  }


  return {
    isDisabled: function(optionsKeys, option, type){
      var silhouette = disabledMap[optionsKeys.silhouette];
      if(type === 'fit'){
        var fit = silhouette.disabledFits[optionsKeys.style];
        return fit ? !!fit[option.name] : false;
      }

      if(type === 'style'){
        var style = silhouette.disabledStyles[optionsKeys.fit];
        return style ? !!style[option.name] : false;
      }


      if(type === 'length'){
        if(optionsKeys.silhouette === 'FP2213'){
          debugger;
        }
        var fit = silhouette.disabledLengths[optionsKeys.fit],
            length = fit ? fit[optionsKeys.style] : false;
        return length ? !!length[optionsKeys.length] : false;
      }
    }
  }
})();
