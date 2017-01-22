function DressImageBuilder(customizations){
  var lengthMap = { ankle: 'AK', petti: 'PT', midi: 'MD', mini: 'MN', maxi: 'MX', knee: 'KN'};
  this.basePath = 'https://d1msb7dh8kb0o9.cloudfront.net/wedding-atelier/dresses/';
  this.silhouetteName = customizations.silhouette ? customizations.silhouette.sku : 'FP2212';
  this.colorName = customizations.color ? customizations.color.name : 'CHAMPAGNE';
  this.fabricName = customizations.fabric ? customizations.fabric.name : 'HG';
  this.styleName = customizations.style ? customizations.style.name : 'S0';
  this.fitName = customizations.fit ? customizations.fit.name : 'F0';
  this.lengthName = customizations.length ? customizations.length.name : 'AK';
}

DressImageBuilder.prototype.buildImagesStyles = function(fileName){
  return {
    thumbnail: {
      white: this.basePath + '180x260/white/' + fileName + '.jpg',
      grey: this.basePath + '180x260/grey/' + fileName + '.jpg'
    },
    moodboard: this.basePath + '280x404/' + fileName + '.jpg',
    normal: this.basePath + '900x1300/' + fileName + '.jpg',
    large: this.basePath + '1800x2600/' + fileName + '.jpg',
  }
}

DressImageBuilder.prototype.silhouette = function(silhouette, pov){
  var fileName = [silhouette.sku, this.fabricName, this.colorName, 'S0', 'F0', this.lengthName, 'FRONT'].join('-').toUpperCase()
  return this.buildImagesStyles(fileName);
}

DressImageBuilder.prototype.length = function(length, pov){
  var fileName = [this.silhouetteName, this.fabricName, this.colorName, 'S0', 'F0', length.name, 'FRONT'].join('-').toUpperCase()
  return this.buildImagesStyles(fileName);
}

DressImageBuilder.prototype.fit = function(fit, pov){
  var fileName = [this.silhouetteName, this.fabricName, this.colorName, 'S0', fit.name, this.lengthName, 'front'].join('-').toUpperCase()
  return this.buildImagesStyles(fileName);
}

DressImageBuilder.prototype.style = function(style, pov){
  var fileName = [this.silhouetteName, this.fabricName, this.colorName, style.name, 'F0', this.lengthName, 'FRONT'].join('-').toUpperCase()
  return this.buildImagesStyles(fileName);
}

DressImageBuilder.prototype.dressCombos = function(){
  var renderImageKeys = [this.silhouetteName, this.fabricName, this.colorName, this.styleName, this.fitName, this.lengthName];
  var realImageKeys = [this.silhouetteName, this.fabricName, this.colorName, 'S0', 'F0', 'AK'];
  var realImageName = realImageKeys.join('-').toUpperCase() + '-';
  var renderImageName = renderImageKeys.join('-').toUpperCase() + '-';
  return {
    front: {
      thumbnail: {
        white: this.basePath + '180x260/white/' + renderImageName + 'FRONT.jpg',
        grey: this.basePath + '180x260/grey/' + renderImageName + 'FRONT.jpg'
      },
      moodboard: this.basePath + '280x404/' + renderImageName + 'FRONT.jpg',
      normal: this.basePath + '900x1300/' + renderImageName + 'FRONT.jpg',
      large: this.basePath + '1800x2600/' + renderImageName + 'FRONT.jpg'
    },
    back: {
      thumbnail: {
        white: this.basePath + '180x260/white/' + renderImageName + 'BACK.jpg',
        grey: this.basePath + '180x260/grey/' + renderImageName + 'BACK.jpg'
      },
      moodboard: this.basePath + '280x404/' + renderImageName + 'BACK.jpg',
      normal: this.basePath + '900x1300/' + renderImageName + 'BACK.jpg',
      large: this.basePath + '1800x2600/' + renderImageName + 'BACK.jpg'
    },
    real: {
      thumbnails: [
         this.basePath + '350x500/' + realImageName + 'FRONT.jpg',
         this.basePath + '350x500/' + realImageName + 'BACK.jpg',
         this.basePath + '350x500/' + realImageName + '1.jpg',
         this.basePath + '350x500/' + realImageName + '2.jpg',
         this.basePath + '350x500/' + realImageName + '3.jpg',
         this.basePath + '350x500/' + realImageName + '4.jpg'
      ],
      large: [
         this.basePath + '1440x1310/' + realImageName + 'FRONT.jpg',
         this.basePath + '1440x1310/' + realImageName + 'BACK.jpg',
         this.basePath + '1440x1310/' + realImageName + '1.jpg',
         this.basePath + '1440x1310/' + realImageName + '2.jpg',
         this.basePath + '1440x1310/' + realImageName + '3.jpg',
         this.basePath + '1440x1310/' + realImageName + '4.jpg'
      ]
    }
  }
}
