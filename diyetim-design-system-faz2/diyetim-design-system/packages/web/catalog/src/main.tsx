import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import '@diyetim/ui/styles.css';
import { ThemeProvider, Text, Stack, Surface } from '@diyetim/ui';
import { stories } from './stories';
import './catalog.css';

const q = new URLSearchParams(location.search);
const only = q.get('story');
const theme = (q.get('theme') ?? 'light') as 'light' | 'dark';
const list = only ? stories.filter((s) => s.id === only) : stories;

function App() {
  if (only) {
    return (
      <ThemeProvider mode={theme} global>
        <main className="cat-single" data-story={only}>{list.map((s) => <section key={s.id} aria-label={s.title}>{s.render()}</section>)}</main>
      </ThemeProvider>
    );
  }
  return (
    <ThemeProvider mode={theme} global>
      <main className="cat">
        <Text variant="h1">Diyetim · Web component kataloğu</Text>
        <Text tone="secondary">Faz 2 · Grup A (primitives) ve Grup B (form ve giriş). ?theme=dark · ?story=button</Text>
        {list.map((s) => (
          <Surface as="section" key={s.id} padding="2xl" radius="xl" elevation="low" aria-label={s.title}>
            <Stack gap="lg"><Text variant="h3">{s.group} · {s.title}</Text>{s.render()}</Stack>
          </Surface>
        ))}
      </main>
    </ThemeProvider>
  );
}

createRoot(document.getElementById('root')!).render(<StrictMode><App /></StrictMode>);
