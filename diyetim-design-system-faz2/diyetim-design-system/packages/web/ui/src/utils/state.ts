import type { ComponentState } from '@diyetim/tokens';

/** Etkileşimli öğelerin ARIA ve davranış öznitelikleri. disabled ve locked bilinçli olarak farklıdır. */
export function interactionProps(state: ComponentState, describedBy?: string) {
  return {
    disabled: state === 'disabled' || undefined,
    'aria-disabled': state === 'locked' || state === 'loading' ? true : undefined,
    'aria-busy': state === 'loading' || undefined,
    'aria-describedby': describedBy,
    'data-state': state,
  } as const;
}

export const isInert = (state: ComponentState) => state !== 'enabled';
