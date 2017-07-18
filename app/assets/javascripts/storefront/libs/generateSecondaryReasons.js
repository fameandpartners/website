export default function (primaryReason = '') {
	switch(primaryReason.constantName) {
		case "DELIVERY_ISSUES":
			return [
				{displayText: "My order was late, so I missed my event", constantName: "ORDER_LATE"},
				{displayText: "I only received part of my order", constantName: "RECEIVED_PARTIAL_ORDER"},
				{displayText: "I received a different style to what I ordered", constantName: "RECEIVED_DIFFERENT_STYLES"},
				{displayText: "The delivery times on the website were not clear", constantName: "UNCLEAR_DELIVERY_TIMES"},
				{displayText: "I received a different size to what I ordered", constantName: "DIFFERENT_SIZE"},
				{displayText: "My order was held up in transit", constantName: "TRANSIT_ISSUES"},				
			]
		case "LOOKS_DIFFERENT":
			return [
					{displayText: "Dress does not sit on the body as shown on the website", constantName: "SIT"},
					{displayText: "The dress simply didn't meet my expectations", constantName: "EXPECTATIONS"},
					{displayText: "Colour does not match the colour displayed on the website", constantName: "COLOR"},
					{displayText: "Fabric is different to what is represented on the website", constantName: "FABRIC"}
				   ]
		case "ORDERED_MULTIPLE":
			return [
				{displayText: "I was not sure which dress would suit me", constantName: "UNSURE"},
				{displayText: "I loved so many dresses I found it difficult to choose", constantName: "TOO_MUCH_LOVE"},
				{displayText: "I was unsure of the best size for me", constantName: "SIZE"}	
			]
		case "POOR_QUALITY":
			return [
				{displayText: "Fabric was poor quality", constantName: "POOR_QUALITY_FABRIC"},
				{displayText: "Dress was poorly made, in my opinion", constantName: "POORLY__MADE"},
				{displayText: "Dress had marks on it", constantName: "DRESS_HAD_MARKS"},
				{displayText: "Dress was damaged when it arrived", constantName: "DRESS_DAMAGED"},
				{displayText: "Lining fabric looked cheap", constantName: "CHEAP_FABRIC"},
				{displayText: "I did not receive my customisation", constantName: "NO_CUSTOMIZATION"},
				{displayText: "Zipper was damaged", constantName: "ZIPPER_DAMAGED"},
			]
		case "SIZE_AND_FIT":
			return [
				{displayText: "I did not receive my customisation", constantName: "CUSTOMIZED_NOT_RECEIVED"},
				{displayText: "Fit was unflattering", constantName: "UNFLATTERING"},
				{displayText: "Dress was too big around the bust", constantName: "BUST_TOO_BIG"},
				{displayText: "Dress was too small around the bust", constantName: "BUST_TOO_SMALL"},
				{displayText: "Dress was too long", constantName: "BUST_TOO_LONG"},
				{displayText: "Dress was too small around the waist", constantName: "BUST_TOO_SMALL_WAIST"},
				{displayText: "Dress was too short", constantName: "BUST_TOO_SHORT"},
				{displayText: "Dress was too big around the waist", constantName: "TOO_BIG_WAIST"},
				{displayText: "Dress was too tight on the hips", constantName: "TOO_TIGHT_HIPS"},
				{displayText: "Neckline was too low or too open", constantName: "NECKLINE_TOO_LOW"},
				{displayText: "Shoulder straps were too long", constantName: "SHOULDER_STRAPS_TOO_LONG"},
				{displayText: "Dress was too loose on the hips", constantName: "LOOSE_HIPS"},
				{displayText: "Neck tie was too tight", constantName: "NECKTIE_TOO_TIGHT"},
			]
		default:
			return []
	}
}
