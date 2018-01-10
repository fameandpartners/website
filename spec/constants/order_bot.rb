module OrderBot
	MEASURE_TYPE_RESPONSE = '[
      {
          "units_of_measure_id": 3297,
          "name": "Piece"
      },
      {
          "units_of_measure_id": 3298,
          "name": "Package"
      },
      {
          "units_of_measure_id": 3299,
          "name": "Copy"
      },
      {
          "units_of_measure_id": 3300,
          "name": "Bundle"
      },
      {
          "units_of_measure_id": 3313,
          "name": "Pad"
      },
      {
          "units_of_measure_id": 3314,
          "name": "Set"
      },
      {
          "units_of_measure_id": 3315,
          "name": "File"
      },
      {
          "units_of_measure_id": 3316,
          "name": "Pack"
      }
  	]'

  	PRODUCT_RESPONSE = '[
	    {
	        "success": true,
	        "message": "Product successfully created",
	        "reference_product_id": "1389",
	        "orderbot_product_id": 2875142
	    }
	]'
  
    PRODUCT_FAILURE_RESPONSE = '[
      {
          "success": false,
          "message": "Cannot create product. There is already a product using this SKU(FP2437US2AU6C2z6XHP).",
          "reference_product_id": "1389",
          "orderbot_product_id": 0
      }
    ]'

  	MEASURE_TYPE_URI = 'LiveTest%40API.com:Testing2000@https://api.orderbot.com/admin/units_of_measurement_types.json/'

  	PRODUCT_URI = 'LiveTest%40API.com:Testing2000@https://api.orderbot.com/admin/products.json/'


end