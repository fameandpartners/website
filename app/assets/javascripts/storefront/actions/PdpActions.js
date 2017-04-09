import { defaultMakingOption } from '../components/PDP/models/MakingOption';

export function customizeDress(customize) {
  return { type: 'CUSTOMIZE_DRESS', customize };
}

export function toggleDrawer(drawerName) {
  return { type: 'TOGGLE_PDP_DRAWER', drawerName };
}

export function addToBagPending(isPending) {
  return {
    type: 'ADD_TO_BAG_PENDING',
    addToBagPending: isPending,
  };
}

export function customizeMakingOption(customize) {
  // TODO: this rule is duplicated at the SidePanelFastMaking
  const isCustomColor = customize.color && customize.color.price > 0;

  if (isCustomColor) {
    const makingOption = Object.assign({}, defaultMakingOption, { error: true });
    customize.makingOption = makingOption;
  }

  return { type: 'CUSTOMIZE_MAKING_OPTION', customize };
}
