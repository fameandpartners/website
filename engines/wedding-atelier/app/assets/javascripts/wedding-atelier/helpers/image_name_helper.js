function DressImageBuilder(customizations){
  var lengthMap = { ankle: 'AK', petti: 'PT', midi: 'MD', mini: 'MN', maxi: 'MX', knee: 'KN'};
  this.basePath = '/assets/wedding-atelier/dresses/';
  this.silhouette = customizations.silhouette ? customizations.silhouette.sku : 'FP2212';
  this.fabric = customizations.fabric ? customizations.fabric.name : 'HG';
  this.colour = customizations.colour ? customizations.colour.name : 'CHAMPAGNE';
  this.style = customizations.style ? customizations.style.name : 'S0';
  this.fit = customizations.fit ? customizations.fit.name : 'F0';
  this.length = customizations.length ? customizations.length.name : 'AK';
  this.customizationNames = [this.silhouette, this.fabric, this.colour, this.style, this.fit, this.length];
}

DressImageBuilder.prototype.styles = function(){
  var imageName = this.customizationNames.join('-').toUpperCase() + '-';
  return ['FRONT', 'BACK'].map(function (type) {
    return {
      thumbnail: this.basePath + '180x260/' + imageName + type + '.jpg',
      moodboard: this.basePath + '280x404/' + imageName + type + '.jpg',
      normal: this.basePath + '900x1300/' + imageName + type + '.jpg',
      large: this.basePath + '1800x2600/' + imageName + type + '.jpg'
    };
  }.bind(this));
}
