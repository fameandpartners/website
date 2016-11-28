export class MakingOption {
  constructor({id = null, price = 0}) {
    this.price = price;
    this.id    = id;
  }

  get displayPrice() {
    let price = parseFloat(this.price) || 0;
    return price.toFixed(0);
  }
}

export const defaultMakingOption = new MakingOption({ id: null, price: 0 });
