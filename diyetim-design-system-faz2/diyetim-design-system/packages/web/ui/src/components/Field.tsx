import { useId, type ReactNode } from 'react';
import type { ComponentState, ValidationState } from '@diyetim/tokens';
import { cx } from '../utils/cx';
import { Icon } from '../primitives/Icon';

export interface FieldBaseProps {
  /** Görünür etiket. Placeholder etiketin yerine geçmez. */
  label: string;
  /** Etiketi görsel olarak gizler (ör. arama çubuğu); ekran okuyucu yine okur. */
  hideLabel?: boolean;
  /** Alanın altındaki yardım metni. */
  description?: string;
  /** Hata metni. Verildiğinde alan hata durumuna geçer; ne olduğunu ve nasıl düzeltileceğini söylemeli. */
  error?: string;
  /** Başarı metni (ör. "Kaydedildi"). error ile birlikte verilmez. */
  success?: string;
  /** enabled · disabled · locked · loading. */
  state?: ComponentState;
  /** locked iken gösterilen neden: "Diyetisyenin gramaj değişikliğini kapattı." */
  lockedReason?: string;
  required?: boolean;
}

export interface FieldIds {
  inputId: string;
  labelId: string;
  describedBy: string | undefined;
  invalid: boolean;
  validation: ValidationState;
}

/** Tüm form alanlarının ortak kabuğu: etiket, açıklama, hata/başarı, kilit nedeni ve ARIA bağlantıları. */
export function FieldShell({
  label, hideLabel, description, error, success, state = 'enabled', lockedReason, required, className, labelAs = 'label', children,
}: FieldBaseProps & { className?: string; labelAs?: 'label' | 'span'; children: (ids: FieldIds) => ReactNode }) {
  const base = useId();
  const inputId = `${base}-input`;
  const labelId = `${base}-label`;
  const descId = `${base}-desc`;
  const msgId = `${base}-msg`;
  const lockId = `${base}-lock`;
  const validation: ValidationState = error ? 'error' : success ? 'success' : 'none';
  const describedBy = cx(description && descId, validation !== 'none' && msgId, state === 'locked' && lockedReason && lockId) || undefined;
  const LabelTag = labelAs;
  return (
    <div className={cx('dy-field', `dy-field--${state}`, validation !== 'none' && `dy-field--${validation}`, className)} data-state={state} data-validation={validation}>
      <LabelTag id={labelId} {...(labelAs === 'label' ? { htmlFor: inputId } : {})} className={cx('dy-field__label', hideLabel && 'dy-visually-hidden')}>
        {label}
        {required ? <span className="dy-field__required" aria-hidden="true"> *</span> : null}
      </LabelTag>
      {children({ inputId, labelId, describedBy, invalid: validation === 'error', validation })}
      {description ? <p id={descId} className="dy-field__help">{description}</p> : null}
      {state === 'locked' && lockedReason ? (
        <p id={lockId} className="dy-field__help dy-field__locked"><Icon name="lock" size="sm" />{lockedReason}</p>
      ) : null}
      {validation === 'error' ? (
        <p id={msgId} className="dy-field__message dy-field__message--error" role="alert"><Icon name="alert" size="sm" />{error}</p>
      ) : validation === 'success' ? (
        <p id={msgId} className="dy-field__message dy-field__message--success" role="status"><Icon name="checkCircle" size="sm" />{success}</p>
      ) : null}
    </div>
  );
}
