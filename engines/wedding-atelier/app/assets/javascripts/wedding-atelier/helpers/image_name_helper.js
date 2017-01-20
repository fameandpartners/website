function DressImageBuilder(customizations){
  var lengthMap = { ankle: 'AK', petti: 'PT', midi: 'MD', mini: 'MN', maxi: 'MX', knee: 'KN'};
  this.basePath = 'https://d1msb7dh8kb0o9.cloudfront.net/wedding-atelier/dresses/';
  this.silhouetteName = customizations.silhouette ? customizations.silhouette.sku : 'FP2212';
  this.colorName = customizations.color ? customizations.color.name : 'CHAMPAGNE';
  // this.fabricName = customizations.fabric ? customizations.fabric.name : 'HG';
  this.fabricName = 'HG';
  this.styleName = customizations.style ? customizations.style.name : 'S0';
  this.fitName = customizations.fit ? customizations.fit.name : 'F0';
  this.lengthName = customizations.length ? customizations.length.name : 'AK';
}

DressImageBuilder.prototype.silhouette = function(silhouette){
  var fileName = [silhouette.sku, this.fabricName, this.colorName, 'S0', 'F0', this.lengthName, 'FRONT'].join('-').toUpperCase()
  return {
    thumbnail: {
      white: this.basePath + '180x260/white/' + fileName + '.jpg',
      grey: this.basePath + '180x260/grey/' + fileName + '.jpg'
    },
    moodboard: this.basePath + '280x404/' + fileName + '.jpg',
    normal: this.basePath + '900x1300/' + fileName + '.jpg',
    large: this.basePath + '1800x2600/' + fileName + '.jpg'
  }
}

DressImageBuilder.prototype.length = function(length){
  var fileName = [this.silhouetteName, this.fabricName, this.colorName, 'S0', 'F0', length.name, 'FRONT'].join('-').toUpperCase()
  return {
    thumbnail: {
      white: this.basePath + '180x260/white/' + fileName + '.jpg',
      grey: this.basePath + '180x260/grey/' + fileName + '.jpg'
    },
    moodboard: this.basePath + '280x404/' + fileName + '.jpg',
    normal: this.basePath + '900x1300/' + fileName + '.jpg',
    large: this.basePath + '1800x2600/' + fileName + '.jpg'
  }
}

DressImageBuilder.prototype.fit = function(fit){
  var fileName = [this.silhouetteName, this.fabricName, this.colorName, 'S0', fit.name, this.lengthName, 'front'].join('-').toUpperCase()
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

DressImageBuilder.prototype.style = function(style){
  var fileName = [this.silhouetteName, this.fabricName, this.colorName, style.name, 'F0', this.lengthName, 'FRONT'].join('-').toUpperCase()
  return {
    thumbnail: {
      white: this.basePath + '180x260/white/' + fileName + '.jpg',
      grey: this.basePath + '180x260/grey/' + fileName + '.jpg'
    },
    moodboard: this.basePath + '280x404/' + fileName + '.jpg',
    normal: this.basePath + '900x1300/' + fileName + '.jpg',
    large: this.basePath + '1800x2600/' + fileName + '.jpg'
  }
}

DressImageBuilder.prototype.dressCombos = function(){
  var fileName = [this.silhouetteName, this.fabricName, this.colorName, this.styleName, this.fitName, this.lengthName];
  var realImageFile = [this.silhouetteName, this.fabricName, this.colorName, 'S0', 'F0', 'AK', 'FRONT'];
  var realImage = realImageFile.join('-').toUpperCase();
  var imageName = fileName.join('-').toUpperCase() + '-';
  return ['FRONT', 'BACK'].map(function (type) {
    return {
      thumbnail: {
        white: this.basePath + '180x260/white/' + imageName + type + '.jpg',
        grey: this.basePath + '180x260/grey/' + imageName + type + '.jpg'
      },
      moodboard: this.basePath + '280x404/' + imageName + type + '.jpg',
      normal: this.basePath + '900x1300/' + imageName + type + '.jpg',
      large: this.basePath + '1800x2600/' + imageName + type + '.jpg',
      real: {
        small: this.basePath + '350x500/' + realImage + '.jpg',
        large: this.basePath + '1440x1310/' + realImage + '.jpg'
      }
    };
  }.bind(this));
}
