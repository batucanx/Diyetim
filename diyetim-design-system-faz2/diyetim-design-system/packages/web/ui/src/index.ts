// @diyetim/ui — Faz 2 (Grup A–B). Stil: import '@diyetim/ui/styles.css'.
export { ThemeProvider, useTheme, type ThemeProviderProps, type ThemeMode, type Density } from './theme/ThemeProvider';
export { Text, type TextProps } from './primitives/Text';
export { NumberDisplay, type NumberDisplayProps } from './primitives/NumberDisplay';
export { Icon, type IconProps, type IconName, type IconSize } from './primitives/Icon';
export { Surface, type SurfaceProps } from './primitives/Surface';
export { Stack, Gap, type StackProps, type GapProps } from './primitives/Stack';
export { Skeleton, type SkeletonProps } from './primitives/Skeleton';
export { Pressable, type PressableProps } from './primitives/Pressable';
export { Button, IconButton, Fab, type ButtonProps, type IconButtonProps, type FabProps } from './components/Button';
export { TextField, SearchField, NumberField, type TextFieldProps, type SearchFieldProps, type NumberFieldProps } from './components/TextField';
export { Textarea, type TextareaProps } from './components/Textarea';
export { Select, MultiSelect, type SelectProps, type MultiSelectProps, type SelectOption } from './components/Select';
export { Checkbox, type CheckboxProps } from './components/Checkbox';
export { RadioGroup, type RadioGroupProps, type RadioOption } from './components/RadioGroup';
export { Switch, type SwitchProps } from './components/Switch';
export { SegmentedControl, type SegmentedControlProps, type SegmentOption } from './components/SegmentedControl';
export { formatNumber, parseNumber } from './utils/format';
export { iconPaths } from './icons/paths';
