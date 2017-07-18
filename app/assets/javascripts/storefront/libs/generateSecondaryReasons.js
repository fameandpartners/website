export default function (primaryReason = '') {
	switch(primaryReason) {
		case "DELIVERY_ISSUES":
			return {
				"ORDER_LATE": {
					name: "My order was late, so I missed my event"
				},
				"RECEIVED_PARTIAL_ORDER": {
					name: "I only received part of my order"
				},
				"RECEIVED_DIFFERENT_STYLES": {
					name: "I received a different style to what I ordered"
				},
				"UNCLEAR_DELIVERY_TIMES": {
					name: "The delivery times on the website were not clear"
				},
				"DIFFERENT_SIZE": {
					name: "I received a different size to what I ordered"
				},
				"TRANSIT_ISSUES": {
					name: "My order was held up in transit"
				}
			}
		case "LOOKS_DIFFERENT":
			return {
					"SIT": {
						name: "Dress does not sit on the body as shown on the website"
					},
					"EXPECTATIONS": {
						name: "The dress simply didn't meet my expectations"
					},
					"COLOR": {
						name: "Colour does not match the colour displayed on the website"
					},
					"FABRIC": {
						name: "Fabric is different to what is represented on the website"
					}
				   }
		case "ORDERED_MULTIPLE":
			return {
				"UNSURE": {
					name: "I was not sure which dress would suit me"
				},
				"TOO_MUCH_LOVE": {
					name: "I loved so many dresses I found it difficult to choose"
				},
				"SIZE": {
					name: "I was unsure of the best size for me"
				}	
			}
		case "POOR_QUALITY":
			return {
				"POOR_QUALITY_FABRIC": {
					name: "Fabric was poor quality"
				},
				"POORLY__MADE": {
					name: "Dress was poorly made, in my opinion"
				},
				"DRESS_HAD_MARKS": {
					name: "Dress had marks on it"
				},
				"DRESS_DAMAGED": {
					name: "Dress was damaged when it arrived"
				},
				"CHEAP_FABRIC": {
					name: "Lining fabric looked cheap"
				},
				"NO_CUSTOMIZATION": {
					name: "I did not receive my customisation"
				},
				"ZIPPER_DAMAGED": {
					name: "Zipper was damaged"
				},
			}
		case "SIZE_AND_FIT":
			return {
				"CUSTOMIZED_NOT_RECEIVED": {
					name: "I did not receive my customisation"
				},
				"UNFLATTERING": {
					name: "Fit was unflattering"
				},
				"BUST_TOO_BIG": {
					name: "Dress was too big around the bust"
				},
				"BUST_TOO_SMALL": {
					name: "Dress was too small around the bust"
				},
				"BUST_TOO_LONG": {
					name: "Dress was too long"
				},
				"BUST_TOO_SMALL_WAIST": {
					name: "Dress was too small around the waist"
				},
				"BUST_TOO_SHORT": {
					name: "Dress was too short"
				},
				"TOO_BIG_WAIST": {
					name: "Dress was too big around the waist"
				},
				"TOO_TIGHT_HIPS": {
					name: "Dress was too tight on the hips"
				},
				"NECKLINE_TOO_LOW": {
					name: "Neckline was too low or too open"
				},
				"SHOULDER_STRAPS_TOO_LONG": {
					name: "Shoulder straps were too long"
				},
				"LOOSE_HIPS": {
					name: "Dress was too loose on the hips"
				},
				"NECKTIE_TOO_TIGHT": {
					name: "Neck tie was too tight"
				},
			}
		default:
			return {}
	}
}
