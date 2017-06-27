const categoryTypes = [
    {
      id: 'dresses',
      displayName: 'Dresses',
      relativePath: '/dresses',
      subCategories: [
         {
           id: 'long',
           displayName: 'Maxi',
           relativePath: '/dresses/long'
         }, {
           id: 'midi',
           displayName: 'Midi',
           relativePath: '/dresses/midi'
         }, {
           id: 'mini',
           displayName: 'Mini',
           relativePath: '/dresses/mini'
         }, {
           id: 'two-piece',
           displayName: 'Two Piece',
           relativePath: '/dresses/two-piece'
         },
         {
           id: 'prom',
           displayName: 'Prom',
           relativePath: '/dresses/prom'
         }, {
           id: 'bridal',
           displayName: 'Bridal',
           relativePath: '/dresses/bridal'
         }, {
           id: 'bridesmaid',
           displayName: 'Bridesmaid',
           relativePath: '/dresses/bridesmaid'
         }, {
           id: 'wedding-guests',
           displayName: 'Wedding Guests',
           relativePath: '/dresses/wedding-guests'
         }, {
           id: 'cocktail',
           displayName: 'Cocktail',
           relativePath: '/dresses/cocktail'
         }, {
           id: 'graduation',
           displayName: 'Graduation',
           relativePath: '/dresses/graduation'
         }
      ]
    }, {
      id: 'skirts',
      displayName: 'Skirts',
      relativePath: '/skirts',
      subCategories: [
      	{
           id: 'maxi',
           displayName: 'Maxi',
           relativePath: '/skirts/maxi'
         },
         {
           id: 'mini',
           displayName: 'Mini',
           relativePath: '/skirts/mini'
         }
      ]
    }, {
      id: 'jumpsuit',
      displayName: 'Jumpsuits & Rompers',
      relativePath: '/dresses/jumpsuit' 
    }, {
      id: 'tops',
      displayName: 'Tops',
      relativePath: '/tops',
      subCategories: [
      	{
           id: 'blouses',
           displayName: 'Blouses',
           relativePath: '/tops/blouses'
         },
         {
           id: 'cropped',
           displayName: 'Cropped',
           relativePath: '/tops/cropped'
         }
      ]
    }, {
      id: 'pants',
      displayName: 'Pants',
      relativePath: '/pants'
    }, {
      id: 'outerwear',
      displayName: 'Outerwear & Jackets',
      relativePath: '/outerwear'
    }
  ]
export default categoryTypes;
