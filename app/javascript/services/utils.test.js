import { formatCurrency } from "./ultils";

describe('formatCurrency', () => {
  test('should format cents correctly', () => {
    expect(formatCurrency(1234)).toBe('$12.34');
    expect(formatCurrency(5000)).toBe('$50.00');
    expect(formatCurrency(100)).toBe('$1.00');
  });

  test('should return $0.00 for 0 cents', () => {
    expect(formatCurrency(0)).toBe('$0.00');
  });

  test('should format large numbers correctly', () => {
    expect(formatCurrency(1000000)).toBe('$10,000.00');
  });

  test('should format numbers with decimals correctly', () => {
    expect(formatCurrency(125)).toBe('$1.25');
  });
});
