import {defaultMakingOption} from '../components/PDP/models/MakingOption';

export function customizeDress(customize) {
  return { type: 'CUSTOMIZE_DRESS', customize };
}

export function customizeMakingOption(customize) {
  // TODO: this rule is duplicated at the SidePanelFastMaking
  let isCustomColor = customize.color && customize.color.price > 0;

  if (isCustomColor) {
    let makingOption = Object.assign({}, defaultMakingOption, {error: true});
    customize.makingOption = makingOption;
  }

  return { type: 'CUSTOMIZE_MAKING_OPTION', customize };
}
