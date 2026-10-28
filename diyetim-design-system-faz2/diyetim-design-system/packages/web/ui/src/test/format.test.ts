import { describe, expect, it } from 'vitest';
import { formatNumber, parseNumber, trStartsWith } from '../utils/format';

describe('formatNumber (tr-TR)', () => {
  it('binlik nokta, ondalık virgül', () => {
    expect(formatNumber(1842)).toBe('1.842');
    expect(formatNumber(6.34)).toBe('6,3');
    expect(formatNumber(68.4, { maximumFractionDigits: 1 })).toBe('68,4');
  });
  it('yüzde Türkçe biçimde önde', () => expect(formatNumber(0.48, { style: 'percent' })).toBe('%48'));
  it('U+202F üretmez (Nunito\'da yok)', () => expect(formatNumber(1234567.5)).not.toMatch(/ /));
});

describe('parseNumber', () => {
  it.each([
    ['6,5', 6.5], ['68,4', 68.4], ['1.842', 1842], ['1.842,5', 1842.5], ['150', 150], ['6.5', 6.5], [' 12 ', 12], ['-3', -3],
  ])('%s → %s', (input, out) => expect(parseNumber(input)).toBe(out));
  it.each(['', 'abc', '-', ',', '1,2,3'])('%s → null', (input) => expect(parseNumber(input)).toBeNull());
});

describe('trStartsWith', () => {
  it('Türkçe büyük/küçük harf: İ/i ve I/ı', () => {
    expect(trStartsWith('İncir', 'i')).toBe(true);
    expect(trStartsWith('Işık', 'ı')).toBe(true);
    expect(trStartsWith('Şeftali', 'ş')).toBe(true);
  });
});
