#!/bin/bash

# ============================================
# Bibliotheca - Автоматическая установка проекта
# ============================================

set -e

echo "🏛️  Создаём проект Bibliotheca..."

# Создаём структуру папок
mkdir -p bibliotheca/src/{database,parsers,services,styles,hooks,components,screens}
mkdir -p bibliotheca/android/app/src/main/{java/com/bibliotheca/widget,res/{layout,drawable,xml}}

cd bibliotheca

# ============================================
# package.json
# ============================================
cat > package.json << 'EOF'
{
  "name": "bibliotheca",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "@capacitor/core": "^6.0.0",
    "@capacitor/android": "^6.0.0",
    "@capacitor/filesystem": "^6.0.0",
    "@capacitor-community/sqlite": "^6.0.0",
    "@capawesome/capacitor-file-picker": "^6.0.0",
    "jszip": "^3.10.1"
  },
  "devDependencies": {
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "typescript": "^5.4.5",
    "vite": "^5.3.1",
    "tailwindcss": "^3.4.4",
    "postcss": "^8.4.38",
    "autoprefixer": "^10.4.19",
    "@tailwindcss/typography": "^0.5.13"
  }
}
EOF

# ============================================
# vite.config.ts
# ============================================
cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: './',
});
EOF

# ============================================
# tsconfig.json
# ============================================
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": false,
    "noUnusedParameters": false
  },
  "include": ["src"]
}
EOF

# ============================================
# tailwind.config.js
# ============================================
cat > tailwind.config.js << 'EOF'
module.exports = {
  content: ["./index.html", "./src/**/*.{js,jsx,ts,tsx}"],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        parchment: { DEFAULT: '#F4F1EA', dark: '#EAE5D9' },
        ink: { DEFAULT: '#2C2825', light: '#4A4541' },
        leather: { DEFAULT: '#1C1A18', light: '#2A2624' },
        brass: { DEFAULT: '#9C815E', light: '#C2A878' },
      },
      fontFamily: {
        serif: ['"Lora"', '"Merriweather"', 'Georgia', 'serif'],
        sans: ['"Inter"', 'system-ui', 'sans-serif'],
      },
      keyframes: {
        'slide-up': { '0%': { transform: 'translateY(100%)', opacity: '0' }, '100%': { transform: 'translateY(0)', opacity: '1' } },
        'slide-down': { '0%': { transform: 'translateY(-100%)', opacity: '0' }, '100%': { transform: 'translateY(0)', opacity: '1' } },
        'fade-in': { '0%': { opacity: '0', transform: 'scale(0.95)' }, '100%': { opacity: '1', transform: 'scale(1)' } },
      },
      animation: {
        'slide-up': 'slide-up 0.3s ease-out',
        'slide-down': 'slide-down 0.3s ease-out',
        'fade-in': 'fade-in 0.2s ease-out',
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
};
EOF

# ============================================
# postcss.config.js
# ============================================
cat > postcss.config.js << 'EOF'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
EOF

# ============================================
# capacitor.config.ts
# ============================================
cat > capacitor.config.ts << 'EOF'
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.bibliotheca',
  appName: 'Bibliotheca',
  webDir: 'dist',
  android: {
    allowMixedContent: true,
  },
};

export default config;
EOF

# ============================================
# index.html
# ============================================
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <title>Bibliotheca</title>
  <link href="https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,600;1,400&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body class="bg-parchment dark:bg-leather">
  <div id="root"></div>
  <script type="module" src="/src/main.tsx"></script>
</body>
</html>
EOF

# ============================================
# src/index.css
# ============================================
cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  margin: 0;
  -webkit-font-smoothing: antialiased;
  overscroll-behavior: none;
}

::selection {
  background-color: #9C815E60;
  color: inherit;
}
EOF

# ============================================
# src/main.tsx
# ============================================
cat > src/main.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

# ============================================
# src/App.tsx
# ============================================
cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { DatabaseService } from './database/dbService';
import { LibraryScreen } from './screens/LibraryScreen';
import { ReaderScreen } from './screens/ReaderScreen';
import { DictionaryScreen } from './screens/DictionaryScreen';
import { OpdsBrowserScreen } from './screens/OpdsBrowserScreen';
import { Book } from './database/dbService';

type Screen =
  | { name: 'library' }
  | { name: 'reader'; bookId: string }
  | { name: 'dictionary' }
  | { name: 'opds' };

export default function App() {
  const [screen, setScreen] = useState<Screen>({ name: 'library' });
  const [ready, setReady] = useState(false);

  useEffect(() => {
    DatabaseService.initialize().then(() => setReady(true));
  }, []);

  if (!ready) {
    return (
      <div className="h-screen flex items-center justify-center bg-parchment dark:bg-leather">
        <p className="font-serif italic text-brass text-xl">Открываем библиотеку...</p>
      </div>
    );
  }

  switch (screen.name) {
    case 'library':
      return (
        <LibraryScreen
          onOpenBook={(book) => setScreen({ name: 'reader', bookId: book.id })}
          onOpenDictionary={() => setScreen({ name: 'dictionary' })}
          onOpenOpds={() => setScreen({ name: 'opds' })}
        />
      );
    case 'reader':
      return <ReaderScreen bookId={screen.bookId} onBack={() => setScreen({ name: 'library' })} />;
    case 'dictionary':
      return <DictionaryScreen onBack={() => setScreen({ name: 'library' })} />;
    case 'opds':
      return (
        <OpdsBrowserScreen
          onBack={() => setScreen({ name: 'library' })}
          onBookImported={() => setScreen({ name: 'library' })}
        />
      );
  }
}
EOF

# ============================================
# src/database/dbService.ts
# ============================================
cat > src/database/dbService.ts << 'EOF'
import { CapacitorSQLite, SQLiteConnection, SQLiteDBConnection } from '@capacitor-community/sqlite';

const sqlite = new SQLiteConnection(CapacitorSQLite);
let db: SQLiteDBConnection | null = null;

export interface Book {
  id: string; title: string; author: string; language: string; format: string;
  file_path: string; cover_path: string | null; total_chapters: number; total_words: number;
  date_added: number; last_opened: number | null; is_favorite: number;
}
export interface ReadingProgress {
  book_id: string; current_chapter_id: string | null; current_cfi: string | null;
  scroll_position: number; percent_read: number; time_spent_seconds: number; updated_at: number;
}
export interface Bookmark {
  id: string; book_id: string; chapter_id: string | null; chapter_title: string | null;
  cfi: string; note: string | null; created_at: number;
}
export interface Annotation {
  id: string; book_id: string; chapter_id: string | null; cfi_range: string;
  selected_text: string; note: string | null; color: string;
  type: 'highlight' | 'underline' | 'note'; created_at: number;
}
export interface OpdsCatalog {
  id: string; title: string; url: string; icon?: string;
  isDefault?: boolean; requiresAuth?: boolean;
}

const SCHEMA = `
CREATE TABLE IF NOT EXISTS books (
  id TEXT PRIMARY KEY, title TEXT NOT NULL, author TEXT, language TEXT DEFAULT 'ru',
  format TEXT NOT NULL, file_path TEXT NOT NULL, cover_path TEXT,
  total_chapters INTEGER DEFAULT 0, total_words INTEGER DEFAULT 0,
  date_added INTEGER NOT NULL, last_opened INTEGER, is_favorite INTEGER DEFAULT 0
);
CREATE TABLE IF NOT EXISTS reading_progress (
  book_id TEXT PRIMARY KEY REFERENCES books(id) ON DELETE CASCADE,
  current_chapter_id TEXT, current_cfi TEXT, scroll_position REAL DEFAULT 0,
  percent_read REAL DEFAULT 0, time_spent_seconds INTEGER DEFAULT 0, updated_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS bookmarks (
  id TEXT PRIMARY KEY, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  chapter_id TEXT, chapter_title TEXT, cfi TEXT NOT NULL, note TEXT, created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS annotations (
  id TEXT PRIMARY KEY, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  chapter_id TEXT, cfi_range TEXT NOT NULL, selected_text TEXT NOT NULL, note TEXT,
  color TEXT DEFAULT '#9C815E', type TEXT DEFAULT 'highlight', created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS user_dictionary (
  id TEXT PRIMARY KEY, word TEXT NOT NULL, translation TEXT, context TEXT,
  book_id TEXT REFERENCES books(id) ON DELETE SET NULL,
  review_count INTEGER DEFAULT 0, next_review_at INTEGER, created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS opds_catalogs (
  id TEXT PRIMARY KEY, title TEXT NOT NULL, url TEXT NOT NULL UNIQUE, icon TEXT,
  requires_auth INTEGER DEFAULT 0, login TEXT, password TEXT,
  sort_order INTEGER DEFAULT 0, created_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_books_title ON books(title);
CREATE INDEX IF NOT EXISTS idx_annotations_book ON annotations(book_id);
`;

export const DatabaseService = {
  async initialize() {
    const ret = await sqlite.checkConnectionsConsistency();
    const isConn = (await sqlite.isConnection('library.db', false)).result;
    if (ret.result && isConn) {
      db = await sqlite.retrieveConnection('library.db', false);
    } else {
      db = await sqlite.createConnection('library.db', false, 'no-encryption', 1, false);
    }
    await db.open();
    await db.execute(SCHEMA);
  },

  async addBook(book: Omit<Book, 'id' | 'date_added'>): Promise<string> {
    if (!db) throw new Error('DB not initialized');
    const id = crypto.randomUUID();
    await db.run(
      `INSERT INTO books (id,title,author,language,format,file_path,cover_path,total_chapters,total_words,date_added)
       VALUES (?,?,?,?,?,?,?,?,?,?)`,
      [id, book.title, book.author, book.language, book.format, book.file_path, book.cover_path,
       book.total_chapters, book.total_words, Date.now()]
    );
    return id;
  },

  async getAllBooks(): Promise<Book[]> {
    if (!db) return [];
    const r = await db.query('SELECT * FROM books ORDER BY last_opened DESC, date_added DESC');
    return r.values ?? [];
  },

  async getBookById(bookId: string): Promise<Book | null> {
    if (!db) return null;
    const r = await db.query('SELECT * FROM books WHERE id = ?', [bookId]);
    return r.values?.[0] ?? null;
  },

  async getAllProgress(): Promise<Map<string, ReadingProgress>> {
    if (!db) return new Map();
    const r = await db.query('SELECT * FROM reading_progress');
    const m = new Map<string, ReadingProgress>();
    for (const row of r.values ?? []) m.set(row.book_id, row as ReadingProgress);
    return m;
  },

  async saveProgress(bookId: string, progress: Partial<ReadingProgress>) {
    if (!db) return;
    const now = Date.now();
    await db.run(
      `INSERT INTO reading_progress (book_id,current_chapter_id,current_cfi,scroll_position,percent_read,time_spent_seconds,updated_at)
       VALUES (?,?,?,?,?,?,?)
       ON CONFLICT(book_id) DO UPDATE SET
         current_chapter_id=excluded.current_chapter_id, current_cfi=excluded.current_cfi,
         scroll_position=excluded.scroll_position, percent_read=excluded.percent_read,
         time_spent_seconds=excluded.time_spent_seconds, updated_at=excluded.updated_at`,
      [bookId, progress.current_chapter_id, progress.current_cfi, progress.scroll_position,
       progress.percent_read, progress.time_spent_seconds, now]
    );
  },

  async addBookmark(b: Omit<Bookmark, 'id' | 'created_at'>): Promise<string> {
    if (!db) throw new Error('DB not initialized');
    const id = crypto.randomUUID();
    await db.run(
      `INSERT INTO bookmarks (id,book_id,chapter_id,chapter_title,cfi,note,created_at) VALUES (?,?,?,?,?,?,?)`,
      [id, b.book_id, b.chapter_id, b.chapter_title, b.cfi, b.note, Date.now()]
    );
    return id;
  },

  async getBookmarks(bookId: string): Promise<Bookmark[]> {
    if (!db) return [];
    const r = await db.query('SELECT * FROM bookmarks WHERE book_id = ? ORDER BY created_at DESC', [bookId]);
    return r.values ?? [];
  },

  async addAnnotation(a: Omit<Annotation, 'id' | 'created_at'>): Promise<string> {
    if (!db) throw new Error('DB not initialized');
    const id = crypto.randomUUID();
    await db.run(
      `INSERT INTO annotations (id,book_id,chapter_id,cfi_range,selected_text,note,color,type,created_at)
       VALUES (?,?,?,?,?,?,?,?,?)`,
      [id, a.book_id, a.chapter_id, a.cfi_range, a.selected_text, a.note, a.color, a.type, Date.now()]
    );
    return id;
  },

  async getAnnotations(bookId: string): Promise<Annotation[]> {
    if (!db) return [];
    const r = await db.query('SELECT * FROM annotations WHERE book_id = ? ORDER BY created_at DESC', [bookId]);
    return r.values ?? [];
  },

  async getCatalogs(): Promise<OpdsCatalog[]> {
    if (!db) return [];
    const r = await db.query('SELECT * FROM opds_catalogs ORDER BY sort_order, title');
    return r.values ?? [];
  },

  async addCatalog(c: Omit<OpdsCatalog, 'id'> & { login?: string; password?: string }): Promise<string> {
    if (!db) throw new Error('DB not initialized');
    const id = crypto.randomUUID();
    await db.run(
      `INSERT INTO opds_catalogs (id,title,url,icon,requires_auth,login,password,sort_order,created_at)
       VALUES (?,?,?,?,?,?,?,?,?)`,
      [id, c.title, c.url, c.icon, c.requiresAuth ? 1 : 0, c.login || null, c.password || null, 0, Date.now()]
    );
    return id;
  },

  async deleteCatalog(id: string) {
    if (!db) return;
    await db.run('DELETE FROM opds_catalogs WHERE id = ?', [id]);
  },
};
EOF
# ============================================
# src/parsers/types.ts
# ============================================
cat > src/parsers/types.ts << 'EOF'
export interface ParsedChapter {
  id: string; title: string; htmlContent: string; order: number; wordCount: number;
}
export interface ParsedBook {
  id: string; title: string; author: string; language: string;
  format: 'epub' | 'fb2'; coverDataUrl: string | null;
  chapters: ParsedChapter[]; totalWords: number;
  assets: { path: string; dataUrl: string }[];
}
export interface BookParser {
  parse(fileData: ArrayBuffer, fileName: string): Promise<ParsedBook>;
}
EOF

# ============================================
# src/parsers/EpubParser.ts
# ============================================
cat > src/parsers/EpubParser.ts << 'EOF'
import JSZip from 'jszip';
import { BookParser, ParsedBook } from './types';

export class EpubParser implements BookParser {
  async parse(fileData: ArrayBuffer, fileName: string): Promise<ParsedBook> {
    const zip = await JSZip.loadAsync(fileData);
    const containerXml = await zip.file('META-INF/container.xml')?.async('string');
    if (!containerXml) throw new Error('Invalid EPUB');
    const containerDoc = new DOMParser().parseFromString(containerXml, 'application/xml');
    const opfPath = containerDoc.querySelector('rootfile')?.getAttribute('full-path');
    if (!opfPath) throw new Error('Invalid EPUB');
    const opfDir = opfPath.includes('/') ? opfPath.substring(0, opfPath.lastIndexOf('/') + 1) : '';
    const opfXml = await zip.file(opfPath)?.async('string');
    if (!opfXml) throw new Error('Invalid EPUB');
    const opfDoc = new DOMParser().parseFromString(opfXml, 'application/xml');
    const title = opfDoc.querySelector('metadata title')?.textContent?.trim() || fileName.replace(/\.epub$/i, '');
    const author = opfDoc.querySelector('metadata creator')?.textContent?.trim() || 'Неизвестный автор';
    const language = opfDoc.querySelector('metadata language')?.textContent?.trim() || 'ru';

    const manifest = new Map<string, { href: string; mediaType: string }>();
    opfDoc.querySelectorAll('manifest item').forEach(item => {
      const id = item.getAttribute('id'), href = item.getAttribute('href'), mediaType = item.getAttribute('media-type');
      if (id && href && mediaType) manifest.set(id, { href, mediaType });
    });

    const spine: string[] = [];
    opfDoc.querySelectorAll('spine itemref').forEach(ref => {
      const idref = ref.getAttribute('idref'); if (idref) spine.push(idref);
    });

    const chapters: any[] = [];
    let totalWords = 0;
    for (let i = 0; i < spine.length; i++) {
      const item = manifest.get(spine[i]);
      if (!item || item.mediaType !== 'application/xhtml+xml') continue;
      const htmlRaw = await zip.file(opfDir + item.href)?.async('string');
      if (!htmlRaw) continue;
      const doc = new DOMParser().parseFromString(htmlRaw, 'application/xhtml+xml');
      const body = doc.body?.innerHTML || '';
      const chapterTitle = doc.querySelector('h1, h2, title')?.textContent?.trim() || `Глава ${i + 1}`;
      const wordCount = (body.replace(/<[^>]+>/g, ' ').match(/\S+/g) || []).length;
      totalWords += wordCount;
      chapters.push({ id: `ch_${i}`, title: chapterTitle, htmlContent: body, order: i, wordCount });
    }

    let coverDataUrl: string | null = null;
    const coverItem = Array.from(manifest.entries()).find(([id, v]) => id.toLowerCase().includes('cover') && v.mediaType.startsWith('image/'));
    if (coverItem) {
      const file = zip.file(opfDir + coverItem[1].href);
      if (file) coverDataUrl = `data:${coverItem[1].mediaType};base64,${await file.async('base64')}`;
    }

    return { id: crypto.randomUUID(), title, author, language, format: 'epub', coverDataUrl, chapters, totalWords, assets: [] };
  }
}
EOF

# ============================================
# src/parsers/Fb2Parser.ts
# ============================================
cat > src/parsers/Fb2Parser.ts << 'EOF'
import { BookParser, ParsedBook } from './types';

export class Fb2Parser implements BookParser {
  async parse(fileData: ArrayBuffer, fileName: string): Promise<ParsedBook> {
    const text = new TextDecoder('utf-8').decode(fileData);
    const doc = new DOMParser().parseFromString(text, 'application/xml');
    if (doc.querySelector('parsererror')) {
      const text1251 = new TextDecoder('windows-1251').decode(fileData);
      const doc2 = new DOMParser().parseFromString(text1251, 'application/xml');
      if (!doc2.querySelector('parsererror')) return this.parseDocument(doc2, fileName);
    }
    return this.parseDocument(doc, fileName);
  }

  private parseDocument(doc: Document, fileName: string): ParsedBook {
    const root = doc.documentElement;
    const titleInfo = root.querySelector('description title-info');
    const title = titleInfo?.querySelector('book-title')?.textContent?.trim() || fileName.replace(/\.fb2$/i, '');
    const authorNode = titleInfo?.querySelector('author');
    const author = authorNode
      ? `${authorNode.querySelector('first-name')?.textContent || ''} ${authorNode.querySelector('last-name')?.textContent || ''}`.trim()
      : 'Неизвестный автор';
    const language = titleInfo?.querySelector('lang')?.textContent || 'ru';

    const binaryMap = new Map<string, string>();
    root.querySelectorAll('binary').forEach(bin => {
      const id = bin.getAttribute('id');
      const contentType = bin.getAttribute('content-type') || 'image/jpeg';
      if (id) binaryMap.set(id, `data:${contentType};base64,${bin.textContent}`);
    });

    let coverDataUrl: string | null = null;
    const coverpage = root.querySelector('description title-info coverpage');
    if (coverpage) {
      const image = coverpage.querySelector('image');
      const href = image?.getAttribute('l:href') || image?.getAttribute('xlink:href');
      if (href?.startsWith('#')) {
        const binary = root.querySelector(`binary[id="${href.substring(1)}"]`);
        if (binary) coverDataUrl = `data:${binary.getAttribute('content-type') || 'image/jpeg'};base64,${binary.textContent}`;
      }
    }

    const chapters: any[] = [];
    let totalWords = 0;
    root.querySelectorAll('body section').forEach((section, idx) => {
      const titleEl = section.querySelector(':scope > title');
      const chapterTitle = titleEl?.textContent?.trim() || `Глава ${idx + 1}`;
      let html = '';
      const convert = (node: Node): string => {
        if (node.nodeType === Node.TEXT_NODE) return node.textContent || '';
        if (node.nodeType !== Node.ELEMENT_NODE) return '';
        const el = node as Element;
        const tag = el.tagName.toLowerCase();
        const children = Array.from(el.childNodes).map(convert).join('');
        switch (tag) {
          case 'p': return `<p>${children}</p>`;
          case 'strong': return `<strong>${children}</strong>`;
          case 'emphasis': return `<em>${children}</em>`;
          case 'empty-line': return `<div style="height:1em;"></div>`;
          case 'stanza': return `<div class="stanza">${children}</div>`;
          case 'v': return `<p class="verse">${children}</p>`;
          case 'cite': case 'epigraph': return `<blockquote>${children}</blockquote>`;
          default: return children;
        }
      };
      for (const child of Array.from(section.childNodes)) {
        const el = child as Element;
        if (el.tagName?.toLowerCase() === 'title' && el.parentElement === section) continue;
        html += convert(child);
      }
      html = html.replace(/<image[^>]*l:href="#([^"]+)"[^>]*\/?>/g, (m, id) => {
        const dataUrl = binaryMap.get(id);
        return dataUrl ? `<img src="${dataUrl}" style="max-width:100%;display:block;margin:1em auto;" />` : '';
      });
      const wordCount = (html.replace(/<[^>]+>/g, ' ').match(/\S+/g) || []).length;
      totalWords += wordCount;
      chapters.push({ id: `ch_${idx}`, title: chapterTitle, htmlContent: html, order: idx, wordCount });
    });

    return { id: crypto.randomUUID(), title, author, language, format: 'fb2', coverDataUrl, chapters, totalWords, assets: [] };
  }
}
EOF

# ============================================
# src/services/SettingsService.ts
# ============================================
cat > src/services/SettingsService.ts << 'EOF'
export type PageTheme = 'parchment' | 'sepia' | 'night' | 'leather';
export type PageTexture = 'none' | 'paper' | 'aged' | 'leather';
export interface ReaderSettings {
  fontSize: number; lineHeight: number; brightness: number;
  pageTheme: PageTheme; pageTexture: PageTexture; fontFamily: 'serif' | 'sans';
}
const DEFAULT: ReaderSettings = {
  fontSize: 18, lineHeight: 1.7, brightness: 100,
  pageTheme: 'parchment', pageTexture: 'paper', fontFamily: 'serif',
};
const KEY = 'bibliotheca_reader_settings';
export const SettingsService = {
  get(): ReaderSettings {
    try { const r = localStorage.getItem(KEY); return r ? { ...DEFAULT, ...JSON.parse(r) } : DEFAULT; }
    catch { return DEFAULT; }
  },
  set(s: Partial<ReaderSettings>): ReaderSettings {
    const next = { ...this.get(), ...s };
    localStorage.setItem(KEY, JSON.stringify(next));
    return next;
  },
};
export const THEME_MAP: Record<PageTheme, { bg: string; text: string; accent: string; muted: string }> = {
  parchment: { bg: '#F4F1EA', text: '#2C2825', accent: '#9C815E', muted: '#4A4541' },
  sepia:     { bg: '#E8DCC4', text: '#3A2E1F', accent: '#8B6F47', muted: '#6B5A42' },
  night:     { bg: '#141210', text: '#C8C2B4', accent: '#C2A878', muted: '#8A8376' },
  leather:   { bg: '#1C1A18', text: '#E3DFD5', accent: '#C2A878', muted: '#9C815E' },
};
EOF

# ============================================
# src/services/ImportService.ts
# ============================================
cat > src/services/ImportService.ts << 'EOF'
import { Directory, Filesystem } from '@capacitor/filesystem';
import { DatabaseService } from '../database/dbService';
import { EpubParser } from '../parsers/EpubParser';
import { Fb2Parser } from '../parsers/Fb2Parser';
import { ParsedBook } from '../parsers/types';

export class ImportService {
  static async importFile(uri: string, fileName: string): Promise<string> {
    const ext = fileName.split('.').pop()?.toLowerCase();
    if (!ext || !['epub', 'fb2'].includes(ext)) throw new Error('Неподдерживаемый формат');
    const result = await Filesystem.readFile({ path: uri, directory: Directory.External });
    const binary = atob(result.data);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
    return this.importFromBuffer(bytes.buffer, fileName);
  }

  static async importFromBuffer(data: ArrayBuffer, fileName: string): Promise<string> {
    const ext = fileName.split('.').pop()?.toLowerCase();
    if (!ext || !['epub', 'fb2'].includes(ext)) throw new Error('Неподдерживаемый формат');
    const parser = ext === 'epub' ? new EpubParser() : new Fb2Parser();
    const parsed = await parser.parse(data, fileName);
    const bookDir = `books/${parsed.id}`;
    if (parsed.coverDataUrl) {
      await Filesystem.writeFile({
        path: `${bookDir}/cover.jpg`,
        data: parsed.coverDataUrl.split(',')[1],
        directory: Directory.Data,
        recursive: true,
      });
    }
    for (const ch of parsed.chapters) {
      await Filesystem.writeFile({
        path: `${bookDir}/${ch.id}.html`,
        data: btoa(unescape(encodeURIComponent(ch.htmlContent))),
        directory: Directory.Data,
        recursive: true,
      });
    }
    return await DatabaseService.addBook({
      title: parsed.title, author: parsed.author, language: parsed.language,
      format: parsed.format, file_path: `data://${parsed.id}`,
      cover_path: `${bookDir}/cover.jpg`,
      total_chapters: parsed.chapters.length, total_words: parsed.totalWords,
    });
  }
}
EOF

# ============================================
# src/services/TranslationService.ts
# ============================================
cat > src/services/TranslationService.ts << 'EOF'
export interface TranslationResult {
  original: string; translated: string; sourceLang: string; targetLang: string; provider: string;
}
export class TranslationService {
  static async translate(text: string, targetLang: string = 'ru'): Promise<TranslationResult> {
    const url = `https://api.mymemory.translated.net/get?q=${encodeURIComponent(text)}&langpair=auto|${targetLang}`;
    const response = await fetch(url);
    const data = await response.json();
    if (data.responseStatus !== 200) throw new Error('Translation failed');
    return {
      original: text, translated: data.responseData.translatedText,
      sourceLang: data.responseData.detectedLanguage || 'auto', targetLang, provider: 'MyMemory',
    };
  }
}
EOF

# ============================================
# src/services/DictionaryService.ts
# ============================================
cat > src/services/DictionaryService.ts << 'EOF'
import { CapacitorSQLite, SQLiteConnection } from '@capacitor-community/sqlite';
const sqlite = new SQLiteConnection(CapacitorSQLite);

export interface DictionaryWord {
  id: string; word: string; translation: string; context: string | null;
  book_id: string | null; review_count: number; next_review_at: number; created_at: number;
}

export const DictionaryService = {
  async addWord(word: string, translation: string, context: string | null = null, bookId: string | null = null): Promise<string> {
    const db = await sqlite.retrieveConnection('library.db', false);
    const id = crypto.randomUUID();
    const now = Date.now();
    await db.run(
      `INSERT INTO user_dictionary (id,word,translation,context,book_id,review_count,next_review_at,created_at) VALUES (?,?,?,?,?,?,?,?)`,
      [id, word, translation, context, bookId, 0, now + 24*60*60*1000, now]
    );
    return id;
  },
  async getAllWords(): Promise<DictionaryWord[]> {
    const db = await sqlite.retrieveConnection('library.db', false);
    const r = await db.query('SELECT * FROM user_dictionary ORDER BY created_at DESC');
    return r.values ?? [];
  },
  async getWordsForReview(): Promise<DictionaryWord[]> {
    const db = await sqlite.retrieveConnection('library.db', false);
    const r = await db.query('SELECT * FROM user_dictionary WHERE next_review_at <= ? ORDER BY next_review_at ASC', [Date.now()]);
    return r.values ?? [];
  },
  async markAsReviewed(wordId: string, remembered: boolean) {
    const db = await sqlite.retrieveConnection('library.db', false);
    const w = await db.query('SELECT * FROM user_dictionary WHERE id = ?', [wordId]);
    if (!w.values?.[0]) return;
    const c = w.values[0];
    const newCount = c.review_count + 1;
    const intervals = [1, 3, 7, 14, 30, 60];
    const nextReview = Date.now() + intervals[Math.min(newCount, intervals.length - 1)] * 24 * 60 * 60 * 1000;
    await db.run('UPDATE user_dictionary SET review_count = ?, next_review_at = ? WHERE id = ?', [newCount, nextReview, wordId]);
  },
  async deleteWord(wordId: string) {
    const db = await sqlite.retrieveConnection('library.db', false);
    await db.run('DELETE FROM user_dictionary WHERE id = ?', [wordId]);
  },
};
EOF

# ============================================
# src/services/TTSService.ts
# ============================================
cat > src/services/TTSService.ts << 'EOF'
export interface Voice { id: string; name: string; lang: string; native: SpeechSynthesisVoice; }
export interface TTSState {
  isPlaying: boolean; isPaused: boolean; currentCharIndex: number;
  currentWordLength: number; rate: number; pitch: number; voice: Voice | null;
}
type Listener = (s: TTSState) => void;

export const TTSService = {
  synth: window.speechSynthesis,
  utterance: null as SpeechSynthesisUtterance | null,
  voices: [] as Voice[],
  state: { isPlaying: false, isPaused: false, currentCharIndex: 0, currentWordLength: 0, rate: 1.0, pitch: 1.0, voice: null } as TTSState,
  listeners: new Set<Listener>(),

  init() {
    const load = () => {
      this.voices = this.synth.getVoices().map(v => ({ id: v.voiceURI, name: v.name, lang: v.lang, native: v }));
      if (!this.state.voice) {
        const ru = this.voices.find(v => v.lang.startsWith('ru'));
        if (ru) this.state.voice = ru;
      }
      this.notify();
    };
    load();
    this.synth.onvoiceschanged = load;
  },
  subscribe(l: Listener) { this.listeners.add(l); l(this.state); return () => this.listeners.delete(l); },
  notify() { this.listeners.forEach(l => l({ ...this.state })); },

  speak(text: string) {
    this.stop();
    const plain = text.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
    this.utterance = new SpeechSynthesisUtterance(plain);
    this.utterance.rate = this.state.rate;
    this.utterance.pitch = this.state.pitch;
    if (this.state.voice) this.utterance.voice = this.state.voice.native;
    this.utterance.lang = this.state.voice?.lang || 'ru-RU';
    this.utterance.onstart = () => { this.state.isPlaying = true; this.state.isPaused = false; this.notify(); };
    this.utterance.onboundary = (e) => {
      if (e.name === 'word') { this.state.currentCharIndex = e.charIndex; this.state.currentWordLength = e.charLength || 0; this.notify(); }
    };
    this.utterance.onend = () => { this.state.isPlaying = false; this.state.isPaused = false; this.state.currentCharIndex = 0; this.notify(); };
    this.synth.speak(this.utterance);
  },
  pause() { if (this.state.isPlaying && !this.state.isPaused) { this.synth.pause(); this.state.isPaused = true; this.notify(); } },
  resume() { if (this.state.isPaused) { this.synth.resume(); this.state.isPaused = false; this.notify(); } },
  stop() { this.synth.cancel(); this.utterance = null; this.state.isPlaying = false; this.state.isPaused = false; this.state.currentCharIndex = 0; this.notify(); },
  toggle() { if (this.state.isPlaying && !this.state.isPaused) this.pause(); else if (this.state.isPaused) this.resume(); },
  setRate(r: number) { this.state.rate = r; if (this.utterance) this.utterance.rate = r; this.notify(); },
  setPitch(p: number) { this.state.pitch = p; if (this.utterance) this.utterance.pitch = p; this.notify(); },
  setVoice(v: Voice) { this.state.voice = v; if (this.utterance) { this.utterance.voice = v.native; this.utterance.lang = v.lang; } this.notify(); },

  highlightCurrentWord(container: HTMLElement) {
    container.querySelectorAll('.tts-highlight').forEach(el => {
      const p = el.parentNode;
      if (p) { p.replaceChild(document.createTextNode(el.textContent || ''), el); p.normalize(); }
    });
    if (!this.state.isPlaying || this.state.currentCharIndex < 0) return;
    let offset = 0;
    const walker = document.createTreeWalker(container, NodeFilter.SHOW_TEXT, null);
    let node = walker.nextNode();
    while (node) {
      const text = node.textContent || '';
      if (offset + text.length > this.state.currentCharIndex) {
        const localOffset = this.state.currentCharIndex - offset;
        const wordLen = this.state.currentWordLength || this.getWordLen(text, localOffset);
        try {
          const range = document.createRange();
          range.setStart(node, localOffset);
          range.setEnd(node, Math.min(localOffset + wordLen, text.length));
          const span = document.createElement('span');
          span.className = 'tts-highlight';
          span.style.cssText = 'background-color: #9C815E40; border-bottom: 2px solid #9C815E;';
          range.surroundContents(span);
          span.scrollIntoView({ behavior: 'smooth', block: 'center' });
        } catch {}
        return;
      }
      offset += text.length;
      node = walker.nextNode();
    }
  },
  getWordLen(text: string, offset: number): number {
    let len = 0;
    for (let i = offset; i < text.length; i++) { if (/\s/.test(text[i])) break; len++; }
    return len;
  },
};
EOF

# ============================================
# src/services/OpdsService.ts
# ============================================
cat > src/services/OpdsService.ts << 'EOF'
export interface OpdsCatalog { id: string; title: string; url: string; icon?: string; requiresAuth?: boolean; }
export interface OpdsEntry { id: string; title: string; author?: string; summary?: string; coverUrl?: string; acquisitionUrl?: string; acquisitionType?: string; }
export interface OpdsFeed {
  title: string; entries: OpdsEntry[];
  navigation: { title: string; href: string }[];
  facets: { title: string; href: string }[];
  nextLink?: string;
}

export const OpdsService = {
  DEFAULT_CATALOGS: [
    { id: 'gutenberg', title: 'Project Gutenberg', url: 'https://m.gutenberg.org/ebooks.opds/', icon: '📕' },
    { id: 'feedbooks', title: 'Feedbooks Public Domain', url: 'https://www.feedbooks.com/publicdomain.opds', icon: '📗' },
    { id: 'standardebooks', title: 'Standard Ebooks', url: 'https://standardebooks.org/opds/all', icon: '📘' },
  ],

  async fetchFeed(url: string, credentials?: { login: string; password: string }): Promise<OpdsFeed> {
    const headers: Record<string, string> = { 'Accept': 'application/atom+xml' };
    if (credentials) headers['Authorization'] = `Basic ${btoa(`${credentials.login}:${credentials.password}`)}`;
    const response = await fetch(url, { headers });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return this.parseFeed(await response.text(), url);
  },

  parseFeed(xmlText: string, baseUrl: string): OpdsFeed {
    const doc = new DOMParser().parseFromString(xmlText, 'application/xml');
    if (doc.querySelector('parsererror')) throw new Error('Invalid OPDS');
    const title = doc.querySelector('feed > title')?.textContent || 'Каталог';
    const entries: OpdsEntry[] = [];
    const navigation: { title: string; href: string }[] = [];
    let nextLink: string | undefined;
    doc.querySelectorAll('feed > link').forEach(link => {
      const rel = link.getAttribute('rel'), href = link.getAttribute('href');
      if (!href) return;
      const abs = this.resolveUrl(baseUrl, href);
      if (rel === 'next') nextLink = abs;
    });
    doc.querySelectorAll('feed > entry').forEach(entry => {
      const id = entry.querySelector('id')?.textContent || crypto.randomUUID();
      const entryTitle = entry.querySelector('title')?.textContent || '';
      const author = entry.querySelector('author name')?.textContent;
      const summary = entry.querySelector('summary')?.textContent?.replace(/<[^>]+>/g, '').trim();
      let acquisitionUrl: string | undefined, acquisitionType: string | undefined, coverUrl: string | undefined;
      entry.querySelectorAll('link').forEach(link => {
        const rel = link.getAttribute('rel'), href = link.getAttribute('href'), type = link.getAttribute('type');
        if (!href) return;
        const abs = this.resolveUrl(baseUrl, href);
        if (rel === 'http://opds-spec.org/acquisition' || rel === 'acquisition') { acquisitionUrl = abs; acquisitionType = type || undefined; }
        else if (rel === 'http://opds-spec.org/image' || rel === 'http://opds-spec.org/image/thumbnail') coverUrl = abs;
        else if (rel === 'subsection' || rel === 'section') navigation.push({ title: entryTitle, href: abs });
      });
      entries.push({ id, title: entryTitle, author, summary, coverUrl, acquisitionUrl, acquisitionType });
    });
    return { title, entries, navigation, facets: [], nextLink };
  },

  resolveUrl(base: string, relative: string): string {
    if (relative.startsWith('http://') || relative.startsWith('https://')) return relative;
    try { return new URL(relative, base).toString(); } catch { return base.replace(/\/[^/]*$/, '/') + relative; }
  },

  async downloadBook(url: string, fileName: string, onProgress?: (p: number) => void): Promise<{ path: string; data: ArrayBuffer }> {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`Download failed`);
    const contentLength = +(response.headers.get('content-length') || 0);
    const reader = response.body?.getReader();
    if (!reader) throw new Error('Streaming not supported');
    const chunks: Uint8Array[] = [];
    let received = 0;
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      chunks.push(value);
      received += value.length;
      if (contentLength > 0 && onProgress) onProgress(Math.round((received / contentLength) * 100));
    }
    const total = chunks.reduce((s, c) => s + c.length, 0);
    const result = new Uint8Array(total);
    let offset = 0;
    for (const chunk of chunks) { result.set(chunk, offset); offset += chunk.length; }
    return { path: fileName, data: result.buffer };
  },
};
EOF

# ============================================
# src/services/CatalogManager.ts
# ============================================
cat > src/services/CatalogManager.ts << 'EOF'
import { DatabaseService } from '../database/dbService';
import { OpdsService } from './OpdsService';

export const CatalogManager = {
  async init() {
    const existing = await DatabaseService.getCatalogs();
    if (existing.length === 0) {
      for (const cat of OpdsService.DEFAULT_CATALOGS) await DatabaseService.addCatalog(cat);
    }
  },
  async getAll() { return DatabaseService.getCatalogs(); },
  async add(c: any) { return DatabaseService.addCatalog(c); },
  async remove(id: string) { return DatabaseService.deleteCatalog(id); },
};
EOF

# ============================================
# src/services/WidgetBridge.ts
# ============================================
cat > src/services/WidgetBridge.ts << 'EOF'
import { registerPlugin } from '@capacitor/core';

interface WidgetBridgePlugin {
  updateCurrentBook(options: { title: string; author: string; percent: number; coverPath?: string }): Promise<void>;
}

const WidgetBridge = registerPlugin<WidgetBridgePlugin>('WidgetBridge');

export const WidgetService = {
  async updateCurrentBook(book: { title: string; author: string; percent: number; coverPath?: string }) {
    try { await WidgetBridge.updateCurrentBook(book); }
    catch (err) { console.warn('Widget update failed:', err); }
  },
};
EOF

# ============================================
# src/styles/textures.ts
# ============================================
cat > src/styles/textures.ts << 'EOF'
export const TEXTURES: Record<string, string> = {
  paper: `url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='200' height='200'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='2' stitchTiles='stitch'/><feColorMatrix values='0 0 0 0 0.6  0 0 0 0 0.5  0 0 0 0 0.4  0 0 0 0.08 0'/></filter><rect width='100%25' height='100%25' filter='url(%23n)'/></svg>")`,
  aged: `url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='300' height='300'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='0.04' numOctaves='3' seed='5'/><feColorMatrix values='0 0 0 0 0.4  0 0 0 0 0.3  0 0 0 0 0.2  0 0 0 0.15 0'/></filter><rect width='100%25' height='100%25' filter='url(%23n)'/></svg>")`,
  leather: `url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='200' height='200'><filter id='n'><feTurbulence type='turbulence' baseFrequency='0.9' numOctaves='2'/><feColorMatrix values='0 0 0 0 0.1  0 0 0 0 0.08  0 0 0 0 0.06  0 0 0 0.25 0'/></filter><rect width='100%25' height='100%25' filter='url(%23n)'/></svg>")`,
  none: 'none',
};
EOF

# ============================================
# src/hooks/usePagination.ts
# ============================================
cat > src/hooks/usePagination.ts << 'EOF'
import { useState, useEffect, useCallback, RefObject } from 'react';

export const usePagination = (htmlContent: string, containerRef: RefObject<HTMLDivElement>) => {
  const [state, setState] = useState({ pages: [] as string[], currentPage: 0, totalPages: 0, isLoading: true });

  useEffect(() => {
    if (!htmlContent || !containerRef.current) return;
    const container = containerRef.current;
    setState(prev => ({ ...prev, isLoading: true }));
    const measureDiv = document.createElement('div');
    measureDiv.style.cssText = `position:absolute;visibility:hidden;width:${container.offsetWidth}px;font-family:${getComputedStyle(container).fontFamily};font-size:${getComputedStyle(container).fontSize};line-height:${getComputedStyle(container).lineHeight};padding:${getComputedStyle(container).padding};`;
    document.body.appendChild(measureDiv);
    measureDiv.innerHTML = htmlContent;
    const pageHeight = container.offsetHeight;
    const pages: string[] = [];
    let current = '', currentH = 0;
    for (const child of Array.from(measureDiv.children)) {
      const h = (child as HTMLElement).offsetHeight;
      if (currentH + h > pageHeight && current) { pages.push(current); current = ''; currentH = 0; }
      if (h > pageHeight) { pages.push((child as HTMLElement).outerHTML); continue; }
      current += (child as HTMLElement).outerHTML;
      currentH += h;
    }
    if (current) pages.push(current);
    document.body.removeChild(measureDiv);
    setState({ pages, currentPage: 0, totalPages: pages.length, isLoading: false });
  }, [htmlContent]);

  const nextPage = useCallback(() => setState(p => ({ ...p, currentPage: Math.min(p.currentPage + 1, p.totalPages - 1) })), []);
  const prevPage = useCallback(() => setState(p => ({ ...p, currentPage: Math.max(p.currentPage - 1, 0) })), []);

  return { ...state, nextPage, prevPage };
};
EOF

# ============================================
# src/hooks/useTextSelection.ts
# ============================================
cat > src/hooks/useTextSelection.ts << 'EOF'
import { useState, useEffect, useCallback } from 'react';

export const useTextSelection = () => {
  const [selection, setSelection] = useState<{ text: string; position: { x: number; y: number }; range: Range | null } | null>(null);

  useEffect(() => {
    const handle = () => {
      const sel = window.getSelection();
      if (!sel || sel.isCollapsed) { setSelection(null); return; }
      const text = sel.toString().trim();
      if (!text) { setSelection(null); return; }
      const range = sel.getRangeAt(0);
      const rect = range.getBoundingClientRect();
      setSelection({ text, position: { x: rect.left + rect.width / 2, y: rect.top }, range });
    };
    document.addEventListener('selectionchange', handle);
    return () => document.removeEventListener('selectionchange', handle);
  }, []);

  const clear = useCallback(() => { window.getSelection()?.removeAllRanges(); setSelection(null); }, []);
  return { selection, clearSelection: clear };
};
EOF
# ============================================
# src/components/PageViewer.tsx
# ============================================
cat > src/components/PageViewer.tsx << 'EOF'
import React, { useRef, useState } from 'react';
import { usePagination } from '../hooks/usePagination';
import { useTextSelection } from '../hooks/useTextSelection';
import { SelectionMenu } from './SelectionMenu';

interface Props {
  htmlContent: string;
  onPageChange: (pageIndex: number, totalPages: number) => void;
  onTapCenter: () => void;
  onQuote: (text: string) => void;
  onTranslate: (text: string) => void;
  onAddToDictionary: (text: string) => void;
  onHighlight: (text: string, color: string) => void;
  contentRef?: React.RefObject<HTMLDivElement>;
}

export const PageViewer: React.FC<Props> = ({
  htmlContent, onPageChange, onTapCenter,
  onQuote, onTranslate, onAddToDictionary, onHighlight, contentRef,
}) => {
  const internalRef = useRef<HTMLDivElement>(null);
  const ref = contentRef || internalRef;
  const { pages, currentPage, totalPages, isLoading, nextPage, prevPage } = usePagination(htmlContent, ref);
  const { selection, clearSelection } = useTextSelection();
  const [isAnimating, setIsAnimating] = useState(false);
  const [slideDirection, setSlideDirection] = useState<'left' | 'right' | null>(null);

  React.useEffect(() => { onPageChange(currentPage, totalPages); }, [currentPage, totalPages]);

  const flip = (dir: 'next' | 'prev') => {
    if (isAnimating) return;
    if (dir === 'next' && currentPage >= totalPages - 1) return;
    if (dir === 'prev' && currentPage <= 0) return;
    setIsAnimating(true);
    setSlideDirection(dir === 'next' ? 'left' : 'right');
    setTimeout(() => {
      if (dir === 'next') nextPage(); else prevPage();
      setSlideDirection(null); setIsAnimating(false);
    }, 250);
  };

  const handleTap = (e: React.MouseEvent | React.TouchEvent) => {
    if (selection) return;
    const rect = ref.current?.getBoundingClientRect();
    if (!rect) return;
    let cx: number, cy: number;
    if ('touches' in e) { cx = e.changedTouches[0].clientX; cy = e.changedTouches[0].clientY; }
    else { cx = e.clientX; cy = e.clientY; }
    const rx = cx - rect.left, ry = cy - rect.top;
    if (ry < rect.height * 0.1 || ry > rect.height * 0.9) return;
    if (rx < rect.width * 0.3) flip('prev');
    else if (rx > rect.width * 0.7) flip('next');
    else onTapCenter();
  };

  const touchStart = useRef<{ x: number; y: number } | null>(null);
  const handleTouchStart = (e: React.TouchEvent) => { touchStart.current = { x: e.touches[0].clientX, y: e.touches[0].clientY }; };
  const handleTouchEnd = (e: React.TouchEvent) => {
    if (!touchStart.current) return;
    const dx = e.changedTouches[0].clientX - touchStart.current.x;
    const dy = e.changedTouches[0].clientY - touchStart.current.y;
    touchStart.current = null;
    if (Math.abs(dx) > 60 && Math.abs(dx) > Math.abs(dy)) flip(dx < 0 ? 'next' : 'prev');
    else if (Math.abs(dy) > 80 && Math.abs(dy) > Math.abs(dx)) flip(dy < 0 ? 'next' : 'prev');
  };

  if (isLoading) return <div className="flex items-center justify-center h-full"><div className="text-brass animate-pulse font-serif italic">Загрузка...</div></div>;

  return (
    <div ref={ref} className="relative h-full w-full overflow-hidden select-text" onClick={handleTap} onTouchStart={handleTouchStart} onTouchEnd={handleTouchEnd}>
      <div className={`absolute inset-0 transition-transform duration-250 ease-out ${slideDirection === 'left' ? '-translate-x-full' : slideDirection === 'right' ? 'translate-x-full' : 'translate-x-0'}`}>
        <div data-page-content className="h-full w-full px-8 py-12 md:px-16 lg:px-24 overflow-hidden font-serif leading-relaxed" dangerouslySetInnerHTML={{ __html: pages[currentPage] || '' }} />
      </div>
      {selection && <SelectionMenu selectedText={selection.text} position={selection.position} onQuote={onQuote} onTranslate={onTranslate} onAddToDictionary={onAddToDictionary} onHighlight={onHighlight} onClose={clearSelection} />}
    </div>
  );
};
EOF

# ============================================
# src/components/SelectionMenu.tsx
# ============================================
cat > src/components/SelectionMenu.tsx << 'EOF'
import React, { useState } from 'react';

interface Props {
  selectedText: string; position: { x: number; y: number };
  onQuote: (t: string) => void; onTranslate: (t: string) => void;
  onAddToDictionary: (t: string) => void; onHighlight: (t: string, c: string) => void;
  onClose: () => void;
}

export const SelectionMenu: React.FC<Props> = ({ selectedText, position, onQuote, onTranslate, onAddToDictionary, onHighlight, onClose }) => {
  const [showColors, setShowColors] = useState(false);
  const colors = [{ id: 'gold', value: '#9C815E' }, { id: 'brass', value: '#C2A878' }, { id: 'sepia', value: '#8B6F47' }, { id: 'ink', value: '#2C2825' }];
  const style: React.CSSProperties = {
    position: 'fixed',
    left: `${Math.max(16, Math.min(position.x - 120, window.innerWidth - 260))}px`,
    top: `${Math.max(16, position.y - 100)}px`,
    zIndex: 50,
  };

  return (
    <>
      <div className="fixed inset-0 z-40 bg-black/20 backdrop-blur-sm" onClick={onClose} />
      <div style={style} className="z-50 bg-parchment dark:bg-leather border border-brass/40 rounded-sm shadow-2xl animate-fade-in">
        {!showColors ? (
          <div className="flex flex-col p-2 min-w-[200px]">
            <div className="px-3 py-2 border-b border-brass/20 mb-2">
              <p className="font-serif text-sm italic text-ink dark:text-parchment line-clamp-2">«{selectedText.slice(0, 80)}»</p>
            </div>
            <button onClick={() => onQuote(selectedText)} className="px-3 py-2 text-left font-sans text-sm text-ink dark:text-parchment hover:bg-brass/10">💬 Цитата</button>
            <button onClick={() => onTranslate(selectedText)} className="px-3 py-2 text-left font-sans text-sm text-ink dark:text-parchment hover:bg-brass/10">🌐 Перевести</button>
            <button onClick={() => onAddToDictionary(selectedText)} className="px-3 py-2 text-left font-sans text-sm text-ink dark:text-parchment hover:bg-brass/10">📖 В словарь</button>
            <button onClick={() => setShowColors(true)} className="px-3 py-2 text-left font-sans text-sm text-ink dark:text-parchment hover:bg-brass/10">🎨 Выделить</button>
          </div>
        ) : (
          <div className="p-3">
            <div className="flex justify-between mb-3">
              <span className="font-sans text-xs uppercase tracking-wider text-ink-light dark:text-parchment/70">Цвет</span>
              <button onClick={() => setShowColors(false)} className="text-brass">←</button>
            </div>
            <div className="flex gap-2">
              {colors.map(c => (
                <button key={c.id} onClick={() => { onHighlight(selectedText, c.value); onClose(); }}
                  className="flex-1 aspect-square rounded-sm border-2 border-brass/30 hover:border-brass" style={{ backgroundColor: c.value }} />
              ))}
            </div>
          </div>
        )}
      </div>
    </>
  );
};
EOF

# ============================================
# src/components/SettingsPanel.tsx
# ============================================
cat > src/components/SettingsPanel.tsx << 'EOF'
import React from 'react';
import { SettingsService, ReaderSettings, PageTheme, PageTexture } from '../services/SettingsService';

interface Props { settings: ReaderSettings; onChange: (s: ReaderSettings) => void; onClose: () => void; }

const THEMES: { id: PageTheme; label: string; preview: string }[] = [
  { id: 'parchment', label: 'Пергамент', preview: '#F4F1EA' },
  { id: 'sepia', label: 'Сепия', preview: '#E8DCC4' },
  { id: 'leather', label: 'Кожа', preview: '#1C1A18' },
  { id: 'night', label: 'Ночь', preview: '#141210' },
];
const TEXTURES: { id: PageTexture; label: string }[] = [
  { id: 'none', label: 'Чисто' }, { id: 'paper', label: 'Бумага' },
  { id: 'aged', label: 'Состаренная' }, { id: 'leather', label: 'Кожа' },
];

export const SettingsPanel: React.FC<Props> = ({ settings, onChange, onClose }) => {
  const update = (p: Partial<ReaderSettings>) => onChange(SettingsService.set(p));

  return (
    <div className="absolute inset-x-0 bottom-0 z-30 animate-slide-up">
      <div className="mx-4 mb-4 rounded-sm border border-brass/30 bg-parchment dark:bg-leather shadow-2xl">
        <div className="flex justify-between px-6 py-3 border-b border-brass/20">
          <span className="text-brass text-xs tracking-[0.3em] uppercase font-sans">Настройки</span>
          <button onClick={onClose} className="text-brass">✕</button>
        </div>
        <div className="p-6 space-y-6">
          <div>
            <div className="flex justify-between mb-2">
              <label className="font-sans text-xs uppercase tracking-wider text-ink-light dark:text-parchment/70">Кегль</label>
              <span className="font-serif text-sm text-brass">{settings.fontSize}px</span>
            </div>
            <input type="range" min="14" max="28" step="1" value={settings.fontSize} onChange={e => update({ fontSize: +e.target.value })} className="w-full accent-brass" />
          </div>
          <div>
            <div className="flex justify-between mb-2">
              <label className="font-sans text-xs uppercase tracking-wider text-ink-light dark:text-parchment/70">Интервал</label>
              <span className="font-serif text-sm text-brass">{settings.lineHeight.toFixed(1)}</span>
            </div>
            <input type="range" min="1.4" max="2.0" step="0.1" value={settings.lineHeight} onChange={e => update({ lineHeight: +e.target.value })} className="w-full accent-brass" />
          </div>
          <div>
            <div className="flex justify-between mb-2">
              <label className="font-sans text-xs uppercase tracking-wider text-ink-light dark:text-parchment/70">Яркость</label>
              <span className="font-serif text-sm text-brass">{settings.brightness}%</span>
            </div>
            <input type="range" min="20" max="100" step="5" value={settings.brightness} onChange={e => update({ brightness: +e.target.value })} className="w-full accent-brass" />
          </div>
          <div>
            <label className="font-sans text-xs uppercase tracking-wider text-ink-light dark:text-parchment/70 block mb-3">Цвет страницы</label>
            <div className="grid grid-cols-4 gap-2">
              {THEMES.map(t => (
                <button key={t.id} onClick={() => update({ pageTheme: t.id })}
                  className={`flex flex-col items-center gap-1.5 p-2 rounded-sm border ${settings.pageTheme === t.id ? 'border-brass bg-brass/10' : 'border-brass/20'}`}>
                  <div className="w-full aspect-[3/4] rounded-sm border border-black/10" style={{ backgroundColor: t.preview }} />
                  <span className="font-sans text-[10px] uppercase tracking-wider text-ink-light dark:text-parchment/70">{t.label}</span>
                </button>
              ))}
            </div>
          </div>
          <div>
            <label className="font-sans text-xs uppercase tracking-wider text-ink-light dark:text-parchment/70 block mb-3">Текстура</label>
            <div className="flex gap-2">
              {TEXTURES.map(t => (
                <button key={t.id} onClick={() => update({ pageTexture: t.id })}
                  className={`flex-1 py-2 font-sans text-xs uppercase tracking-wider rounded-sm border ${settings.pageTexture === t.id ? 'border-brass bg-brass/10 text-brass' : 'border-brass/20 text-ink-light dark:text-parchment/70'}`}>{t.label}</button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
EOF

# ============================================
# src/components/TopPanel.tsx
# ============================================
cat > src/components/TopPanel.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { DatabaseService, Bookmark, Annotation } from '../database/dbService';

interface Chapter { id: string; title: string; order: number; }
interface Props { bookId: string; chapters: Chapter[]; currentChapterIndex: number; onGoToChapter: (i: number) => void; onClose: () => void; }

export const TopPanel: React.FC<Props> = ({ bookId, chapters, currentChapterIndex, onGoToChapter, onClose }) => {
  const [tab, setTab] = useState<'toc' | 'bookmarks' | 'notes'>('toc');
  const [bookmarks, setBookmarks] = useState<Bookmark[]>([]);
  const [annotations, setAnnotations] = useState<Annotation[]>([]);

  useEffect(() => {
    Promise.all([DatabaseService.getBookmarks(bookId), DatabaseService.getAnnotations(bookId)])
      .then(([bm, ann]) => { setBookmarks(bm); setAnnotations(ann); });
  }, [bookId]);

  return (
    <>
      <div className="fixed inset-0 z-40 bg-black/40 backdrop-blur-sm" onClick={onClose} />
      <div className="fixed top-0 left-0 right-0 z-50 max-h-[80vh] bg-parchment dark:bg-leather border-b-2 border-brass/40 shadow-2xl animate-slide-down flex flex-col">
        <div className="border-b border-brass/20">
          <div className="flex justify-between px-6 py-3">
            <span className="text-brass text-xs tracking-[0.3em] uppercase font-sans">Навигация</span>
            <button onClick={onClose} className="text-brass">✕</button>
          </div>
          <div className="flex px-6 gap-1">
            <button onClick={() => setTab('toc')} className={`px-4 py-2 font-sans text-sm border-b-2 ${tab === 'toc' ? 'border-brass text-brass' : 'border-transparent text-ink-light dark:text-parchment/60'}`}>Оглавление</button>
            <button onClick={() => setTab('bookmarks')} className={`px-4 py-2 font-sans text-sm border-b-2 ${tab === 'bookmarks' ? 'border-brass text-brass' : 'border-transparent text-ink-light dark:text-parchment/60'}`}>Закладки {bookmarks.length > 0 && `(${bookmarks.length})`}</button>
            <button onClick={() => setTab('notes')} className={`px-4 py-2 font-sans text-sm border-b-2 ${tab === 'notes' ? 'border-brass text-brass' : 'border-transparent text-ink-light dark:text-parchment/60'}`}>Заметки {annotations.length > 0 && `(${annotations.length})`}</button>
          </div>
        </div>
        <div className="flex-1 overflow-y-auto px-6 py-4">
          {tab === 'toc' && (
            <div className="space-y-1">
              {chapters.map((ch, idx) => (
                <button key={ch.id} onClick={() => onGoToChapter(idx)}
                  className={`w-full flex items-center gap-3 px-3 py-2 text-left rounded-sm ${idx === currentChapterIndex ? 'bg-brass/10 border-l-2 border-brass' : 'hover:bg-brass/5'}`}>
                  <span className="font-serif text-xs text-brass w-8">{String(idx + 1).padStart(2, '0')}</span>
                  <span className={`font-serif text-sm flex-1 ${idx === currentChapterIndex ? 'text-brass font-semibold' : 'text-ink dark:text-parchment'}`}>{ch.title}</span>
                </button>
              ))}
            </div>
          )}
          {tab === 'bookmarks' && (
            bookmarks.length === 0
              ? <p className="text-center py-12 font-serif italic text-ink-light dark:text-parchment/60">Закладок нет</p>
              : <div className="space-y-2">{bookmarks.map(bm => (
                  <div key={bm.id} className="p-3 bg-brass/5 rounded-sm border border-brass/20">
                    {bm.chapter_title && <p className="font-sans text-xs text-brass uppercase tracking-wider mb-1">{bm.chapter_title}</p>}
                    {bm.note && <p className="font-serif text-sm text-ink dark:text-parchment italic">{bm.note}</p>}
                  </div>
                ))}</div>
          )}
          {tab === 'notes' && (
            annotations.length === 0
              ? <p className="text-center py-12 font-serif italic text-ink-light dark:text-parchment/60">Заметок нет</p>
              : <div className="space-y-3">{annotations.map(ann => (
                  <div key={ann.id} className="p-3 rounded-sm border-l-4" style={{ borderLeftColor: ann.color, backgroundColor: `${ann.color}10` }}>
                    <p className="font-serif text-sm text-ink dark:text-parchment italic mb-2">«{ann.selected_text}»</p>
                    {ann.note && <p className="font-sans text-xs text-ink-light dark:text-parchment/80">{ann.note}</p>}
                  </div>
                ))}</div>
          )}
        </div>
      </div>
    </>
  );
};
EOF

# ============================================
# src/components/TranslationPopup.tsx
# ============================================
cat > src/components/TranslationPopup.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { TranslationService } from '../services/TranslationService';
import { DictionaryService } from '../services/DictionaryService';

interface Props { text: string; position: { x: number; y: number }; bookId: string | null; onClose: () => void; }

export const TranslationPopup: React.FC<Props> = ({ text, position, bookId, onClose }) => {
  const [loading, setLoading] = useState(true);
  const [translation, setTranslation] = useState<any>(null);
  const [error, setError] = useState<string | null>(null);
  const [added, setAdded] = useState(false);

  useEffect(() => {
    setLoading(true);
    TranslationService.translate(text, 'ru')
      .then(setTranslation)
      .catch(() => setError('Ошибка перевода'))
      .finally(() => setLoading(false));
  }, [text]);

  const handleAdd = async () => {
    if (!translation) return;
    await DictionaryService.addWord(translation.original, translation.translated, text, bookId);
    setAdded(true);
    setTimeout(onClose, 1500);
  };

  const style: React.CSSProperties = {
    position: 'fixed',
    left: `${Math.max(16, Math.min(position.x - 150, window.innerWidth - 320))}px`,
    top: `${Math.max(16, position.y - 150)}px`,
    zIndex: 60,
  };

  return (
    <>
      <div className="fixed inset-0 z-50 bg-black/30 backdrop-blur-sm" onClick={onClose} />
      <div style={style} className="z-60 w-72 bg-parchment dark:bg-leather border-2 border-brass/50 rounded-sm shadow-2xl animate-fade-in">
        <div className="flex justify-between px-4 py-2 border-b border-brass/30 bg-brass/5">
          <span className="font-sans text-xs uppercase tracking-wider text-brass">Перевод</span>
          <button onClick={onClose} className="text-brass">✕</button>
        </div>
        <div className="p-4">
          {loading && <div className="text-center py-6"><div className="text-brass animate-pulse font-serif italic">Перевод...</div></div>}
          {error && <div className="text-center py-4"><p className="text-red-600 text-sm">{error}</p></div>}
          {translation && (
            <>
              <div className="mb-3">
                <p className="font-sans text-[10px] uppercase tracking-wider text-ink-light/60 mb-1">Оригинал</p>
                <p className="font-serif text-sm text-ink dark:text-parchment italic">{translation.original}</p>
              </div>
              <div className="mb-4 p-3 bg-brass/10 rounded-sm border border-brass/20">
                <p className="font-sans text-[10px] uppercase tracking-wider text-brass mb-1">Перевод</p>
                <p className="font-serif text-base text-ink dark:text-parchment font-semibold">{translation.translated}</p>
              </div>
              <button onClick={handleAdd} disabled={added}
                className={`w-full py-2 rounded-sm font-sans text-sm ${added ? 'bg-green-600/20 text-green-700' : 'bg-brass text-leather hover:bg-brass-light'}`}>
                {added ? '✓ Добавлено' : '📖 В словарь'}
              </button>
            </>
          )}
        </div>
      </div>
    </>
  );
};
EOF

# ============================================
# src/components/TTSControlPanel.tsx
# ============================================
cat > src/components/TTSControlPanel.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { TTSService, TTSState } from '../services/TTSService';

export const TTSControlPanel: React.FC<{ onClose: () => void }> = ({ onClose }) => {
  const [state, setState] = useState<TTSState>(TTSService.state);
  const [showVoices, setShowVoices] = useState(false);

  useEffect(() => {
    TTSService.init();
    return TTSService.subscribe(setState);
  }, []);

  const voices = [...TTSService.voices].sort((a, b) => {
    const aRu = a.lang.startsWith('ru') ? 0 : 1, bRu = b.lang.startsWith('ru') ? 0 : 1;
    return aRu !== bRu ? aRu - bRu : a.name.localeCompare(b.name);
  });

  return (
    <>
      <div className="fixed inset-0 z-40 bg-black/30 backdrop-blur-sm" onClick={onClose} />
      <div className="fixed bottom-0 left-0 right-0 z-50 bg-parchment dark:bg-leather border-t-2 border-brass/40 shadow-2xl animate-slide-up">
        <div className="flex justify-between px-6 py-3 border-b border-brass/20">
          <span className="text-brass text-xs tracking-[0.3em] uppercase font-sans">Чтение вслух</span>
          <button onClick={onClose} className="text-brass">✕</button>
        </div>
        <div className="p-6 space-y-5">
          <div className="flex items-center justify-center gap-4">
            <button onClick={() => TTSService.stop()} disabled={!state.isPlaying && !state.isPaused} className="w-12 h-12 rounded-full border-2 border-brass/40 text-brass disabled:opacity-30">⏹</button>
            <button onClick={() => TTSService.toggle()} className="w-16 h-16 rounded-full bg-brass text-leather shadow-lg">{state.isPlaying && !state.isPaused ? '⏸' : '▶'}</button>
            <div className="w-12" />
          </div>
          <div>
            <div className="flex justify-between mb-2">
              <label className="font-sans text-xs uppercase tracking-wider text-ink-light dark:text-parchment/70">Скорость</label>
              <span className="font-serif text-sm text-brass">{state.rate.toFixed(1)}x</span>
            </div>
            <input type="range" min="0.5" max="2.0" step="0.1" value={state.rate} onChange={e => TTSService.setRate(+e.target.value)} className="w-full accent-brass" />
          </div>
          <div>
            <button onClick={() => setShowVoices(!showVoices)} className="w-full flex justify-between p-3 border border-brass/30 rounded-sm">
              <div className="text-left">
                <p className="font-sans text-[10px] uppercase tracking-wider text-brass">Голос</p>
                <p className="font-serif text-sm text-ink dark:text-parchment">{state.voice?.name || 'Не выбран'}</p>
              </div>
              <span className="text-brass">{showVoices ? '▲' : '▼'}</span>
            </button>
            {showVoices && (
              <div className="mt-2 max-h-48 overflow-y-auto border border-brass/20 rounded-sm bg-parchment-dark dark:bg-leather-light">
                {voices.map(v => (
                  <button key={v.id} onClick={() => { TTSService.setVoice(v); setShowVoices(false); }}
                    className={`w-full text-left px-3 py-2 font-sans text-sm ${state.voice?.id === v.id ? 'bg-brass/20 text-brass' : 'text-ink dark:text-parchment hover:bg-brass/10'}`}>
                    <span className="block">{v.name}</span>
                    <span className="block text-[10px] text-ink-light/60">{v.lang}</span>
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
};
EOF

# ============================================
# src/screens/LibraryScreen.tsx
# ============================================
cat > src/screens/LibraryScreen.tsx << 'EOF'
import React, { useEffect, useState } from 'react';
import { FilePicker } from '@capawesome/capacitor-file-picker';
import { DatabaseService, Book, ReadingProgress } from '../database/dbService';
import { ImportService } from '../services/ImportService';

interface Props { onOpenBook: (b: Book) => void; onOpenDictionary: () => void; onOpenOpds: () => void; }

export const LibraryScreen: React.FC<Props> = ({ onOpenBook, onOpenDictionary, onOpenOpds }) => {
  const [books, setBooks] = useState<Book[]>([]);
  const [progressMap, setProgressMap] = useState<Map<string, ReadingProgress>>(new Map());
  const [filter, setFilter] = useState<'all' | 'reading' | 'favorites'>('all');
  const [search, setSearch] = useState('');

  useEffect(() => { loadBooks(); }, []);

  const loadBooks = async () => {
    const [all, progress] = await Promise.all([DatabaseService.getAllBooks(), DatabaseService.getAllProgress()]);
    setBooks(all); setProgressMap(progress);
  };

  const handleAdd = async () => {
    try {
      const result = await FilePicker.pickFiles({ types: ['application/epub+zip', 'application/xml', 'text/xml'], multiple: false });
      const file = result.files[0];
      if (!file) return;
      await ImportService.importFile(file.path, file.name);
      await loadBooks();
    } catch (err) { alert('Ошибка: ' + (err as Error).message); }
  };

  const filtered = books.filter(b => {
    if (filter === 'favorites' && !b.is_favorite) return false;
    if (filter === 'reading' && !b.last_opened) return false;
    if (search && !b.title.toLowerCase().includes(search.toLowerCase()) && !b.author?.toLowerCase().includes(search.toLowerCase())) return false;
    return true;
  });

  return (
    <div className="min-h-screen bg-parchment dark:bg-leather">
      <header className="px-6 pt-12 pb-6 border-b border-brass/20">
        <div className="max-w-6xl mx-auto">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-8 h-px bg-brass"></div>
            <span className="text-brass text-xs tracking-[0.3em] uppercase font-sans">Bibliotheca</span>
            <div className="flex-1 h-px bg-brass"></div>
          </div>
          <h1 className="font-serif text-4xl md:text-5xl text-ink dark:text-parchment italic">Моя библиотека</h1>
          <p className="text-ink-light dark:text-parchment/60 mt-2 font-sans text-sm">{books.length} том(ов)</p>
          <div className="flex gap-2 mt-4">
            <button onClick={handleAdd} className="px-4 py-2 bg-brass text-leather font-sans text-sm uppercase tracking-wider hover:bg-brass-light rounded-sm">+ Добавить</button>
            <button onClick={onOpenOpds} className="px-4 py-2 border border-brass/40 text-brass font-sans text-sm uppercase tracking-wider hover:bg-brass/10 rounded-sm">📚 Каталоги</button>
            <button onClick={onOpenDictionary} className="px-4 py-2 border border-brass/40 text-brass font-sans text-sm uppercase tracking-wider hover:bg-brass/10 rounded-sm">📖 Словарь</button>
          </div>
        </div>
      </header>

      <div className="max-w-6xl mx-auto px-6 py-6">
        <div className="flex gap-1 bg-parchment-dark dark:bg-leather-light p-1 rounded-sm w-fit">
          {(['all', 'reading', 'favorites'] as const).map(f => (
            <button key={f} onClick={() => setFilter(f)} className={`px-4 py-2 text-sm font-sans ${filter === f ? 'bg-brass text-leather' : 'text-ink-light dark:text-parchment/70'}`}>
              {f === 'all' ? 'Все' : f === 'reading' ? 'Читаю' : 'Избранное'}
            </button>
          ))}
        </div>
        <input type="text" value={search} onChange={e => setSearch(e.target.value)} placeholder="Поиск..."
          className="mt-4 w-full max-w-md bg-transparent border-b border-brass/40 focus:border-brass py-2 font-sans text-sm text-ink dark:text-parchment outline-none" />
      </div>

      <div className="max-w-6xl mx-auto px-6 pb-12">
        {filtered.length === 0 ? (
          <p className="text-center py-24 font-serif text-2xl italic text-ink-light dark:text-parchment/60">Полки пусты...</p>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6">
            {filtered.map(book => {
              const percent = progressMap.get(book.id) ? Math.round(progressMap.get(book.id)!.percent_read) : 0;
              return (
                <button key={book.id} onClick={() => onOpenBook(book)} className="group text-left hover:-translate-y-1 transition-transform">
                  <div className="relative aspect-[2/3] mb-3 overflow-hidden rounded-sm shadow-lg group-hover:shadow-2xl">
                    {book.cover_path ? (
                      <img src={book.cover_path} alt={book.title} className="w-full h-full object-cover" />
                    ) : (
                      <div className="w-full h-full bg-gradient-to-br from-leather to-leather-light flex flex-col items-center justify-center p-4 border border-brass/30">
                        <div className="w-12 h-px bg-brass mb-3"></div>
                        <p className="font-serif text-parchment text-center text-sm italic line-clamp-4">{book.title}</p>
                        <div className="w-12 h-px bg-brass mt-3"></div>
                      </div>
                    )}
                    <div className="absolute inset-y-0 left-0 w-3 bg-gradient-to-r from-black/40 to-transparent"></div>
                    {percent > 0 && (
                      <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-leather/90 to-transparent p-2">
                        <div className="flex justify-between mb-1">
                          <span className="text-brass text-[10px] font-sans uppercase tracking-wider">Прочитано</span>
                          <span className="text-parchment text-sm font-serif font-semibold">{percent}%</span>
                        </div>
                        <div className="h-0.5 bg-parchment/20 rounded-full overflow-hidden">
                          <div className="h-full bg-brass" style={{ width: `${percent}%` }} />
                        </div>
                      </div>
                    )}
                  </div>
                  <h3 className="font-serif text-ink dark:text-parchment text-sm leading-tight line-clamp-2 group-hover:text-brass">{book.title}</h3>
                  {book.author && <p className="font-sans text-xs text-ink-light dark:text-parchment/60 mt-1 line-clamp-1">{book.author}</p>}
                </button>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
};
EOF

# ============================================
# src/screens/ReaderScreen.tsx
# ============================================
cat > src/screens/ReaderScreen.tsx << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import { Filesystem, Directory } from '@capacitor/filesystem';
import { DatabaseService } from '../database/dbService';
import { PageViewer } from '../components/PageViewer';
import { SettingsPanel } from '../components/SettingsPanel';
import { TopPanel } from '../components/TopPanel';
import { TranslationPopup } from '../components/TranslationPopup';
import { TTSControlPanel } from '../components/TTSControlPanel';
import { SettingsService, ReaderSettings, THEME_MAP } from '../services/SettingsService';
import { TTSService } from '../services/TTSService';
import { WidgetService } from '../services/WidgetBridge';
import { TEXTURES } from '../styles/textures';

interface Props { bookId: string; onBack: () => void; }

export const ReaderScreen: React.FC<Props> = ({ bookId, onBack }) => {
  const [chapterHtml, setChapterHtml] = useState('');
  const [chapterTitle, setChapterTitle] = useState('');
  const [currentChapterIndex, setCurrentChapterIndex] = useState(0);
  const [totalChapters, setTotalChapters] = useState(0);
  const [currentPage, setCurrentPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [chapters, setChapters] = useState<{ id: string; title: string; order: number }[]>([]);
  const [settings, setSettings] = useState<ReaderSettings>(SettingsService.get());
  const [showUI, setShowUI] = useState(false);
  const [showSettings, setShowSettings] = useState(false);
  const [showTopPanel, setShowTopPanel] = useState(false);
  const [showPageInfo, setShowPageInfo] = useState(false);
  const [showTTS, setShowTTS] = useState(false);
  const [translationTarget, setTranslationTarget] = useState<{ text: string; position: { x: number; y: number } } | null>(null);
  const [ttsState, setTtsState] = useState(TTSService.state);
  const pageContentRef = useRef<HTMLDivElement>(null);
  const startTime = useRef(Date.now());

  useEffect(() => {
    loadBookData();
    loadChapter(0);
  }, [bookId]);

  useEffect(() => {
    TTSService.init();
    const unsub = TTSService.subscribe(setTtsState);
    return () => { unsub(); TTSService.stop(); };
  }, []);

  useEffect(() => {
    if (ttsState.isPlaying && pageContentRef.current) TTSService.highlightCurrentWord(pageContentRef.current);
  }, [ttsState.currentCharIndex, ttsState.isPlaying]);

  const loadBookData = async () => {
    const book = await DatabaseService.getBookById(bookId);
    if (!book) return;
    setTotalChapters(book.total_chapters);
    const chs = [];
    for (let i = 0; i < book.total_chapters; i++) chs.push({ id: `ch_${i}`, title: `Глава ${i + 1}`, order: i });
    setChapters(chs);
  };

  const loadChapter = async (idx: number) => {
    try {
      const result = await Filesystem.readFile({ path: `books/${bookId}/ch_${idx}.html`, directory: Directory.Data });
      setChapterHtml(decodeURIComponent(escape(atob(result.data))));
      setChapterTitle(chapters[idx]?.title || `Глава ${idx + 1}`);
      setCurrentChapterIndex(idx);
      setCurrentPage(0);
    } catch (err) { console.error(err); }
  };

  useEffect(() => {
    return () => {
      const timeSpent = Math.floor((Date.now() - startTime.current) / 1000);
      const percentRead = totalChapters > 0 ? ((currentChapterIndex + currentPage / Math.max(totalPages, 1)) / totalChapters) * 100 : 0;
      DatabaseService.saveProgress(bookId, {
        current_chapter_id: `ch_${currentChapterIndex}`, current_cfi: null, scroll_position: 0,
        percent_read: percentRead, time_spent_seconds: timeSpent,
      });
      DatabaseService.getBookById(bookId).then(b => {
        if (b) WidgetService.updateCurrentBook({ title: b.title, author: b.author || '', percent: Math.round(percentRead), coverPath: b.cover_path || undefined });
      });
    };
  }, [currentChapterIndex, currentPage, totalPages, totalChapters]);

  const handleTapCenter = () => {
    if (showSettings || showTopPanel) return;
    setShowUI(p => !p); setShowPageInfo(p => !p);
  };

  const theme = THEME_MAP[settings.pageTheme];
  const texture = TEXTURES[settings.pageTexture];
  const pageStyle: React.CSSProperties = {
    backgroundColor: theme.bg, color: theme.text,
    filter: `brightness(${settings.brightness / 100})`,
    backgroundImage: texture, backgroundSize: texture === 'none' ? undefined : 'cover',
    transition: 'background-color 0.5s, color 0.5s, filter 0.3s',
  };
  const textStyle: React.CSSProperties = {
    fontSize: `${settings.fontSize}px`, lineHeight: settings.lineHeight,
    fontFamily: settings.fontFamily === 'serif' ? '"Lora", Georgia, serif' : '"Inter", system-ui, sans-serif',
    color: theme.text,
  };

  const minutesLeft = Math.round(((totalChapters - currentChapterIndex - 1) * totalPages + (totalPages - currentPage - 1)) * 1.5);

  return (
    <div className="h-screen w-screen flex flex-col overflow-hidden" style={pageStyle}>
      <main className="flex-1 relative" style={textStyle}>
        <PageViewer htmlContent={chapterHtml}
          onPageChange={(p, t) => { setCurrentPage(p); setTotalPages(t); }}
          onTapCenter={handleTapCenter}
          onQuote={async (text) => await DatabaseService.addAnnotation({ book_id: bookId, chapter_id: `ch_${currentChapterIndex}`, cfi_range: '', selected_text: text, note: null, color: '#9C815E', type: 'highlight' })}
          onTranslate={(text) => {
            const sel = window.getSelection();
            if (!sel || sel.rangeCount === 0) return;
            const rect = sel.getRangeAt(0).getBoundingClientRect();
            setTranslationTarget({ text, position: { x: rect.left + rect.width / 2, y: rect.top } });
          }}
          onAddToDictionary={async (text) => await DatabaseService.addAnnotation({ book_id: bookId, chapter_id: `ch_${currentChapterIndex}`, cfi_range: '', selected_text: text, note: null, color: '#C2A878', type: 'note' })}
          onHighlight={async (text, color) => await DatabaseService.addAnnotation({ book_id: bookId, chapter_id: `ch_${currentChapterIndex}`, cfi_range: '', selected_text: text, note: null, color, type: 'highlight' })}
          contentRef={pageContentRef} />
      </main>

      <header className={`absolute top-0 left-0 right-0 z-20 flex items-center justify-between px-6 py-4 backdrop-blur-sm transition-all ${showUI ? 'opacity-100' : 'opacity-0 pointer-events-none'}`}
        style={{ background: `linear-gradient(to bottom, ${theme.bg}ee, transparent)` }}>
        <button onClick={onBack} style={{ color: theme.accent }}>←</button>
        <h1 className="font-serif text-lg italic truncate max-w-md" style={{ color: theme.text }}>{chapterTitle}</h1>
        <div className="flex gap-3">
          <button onClick={() => setShowTopPanel(true)} style={{ color: theme.accent }}>☰</button>
          <button onClick={() => { const el = pageContentRef.current?.querySelector('[data-page-content]'); if (el) { TTSService.speak(el.innerHTML); setShowTTS(true); } }} style={{ color: theme.accent }}>🔊</button>
          <button onClick={() => setShowSettings(true)} style={{ color: theme.accent }}>⚙</button>
        </div>
      </header>

      <footer className={`absolute bottom-0 left-0 right-0 z-20 px-6 py-3 backdrop-blur-sm transition-all ${showUI ? 'opacity-100' : 'opacity-0 pointer-events-none'}`}
        style={{ background: `linear-gradient(to top, ${theme.bg}ee, transparent)` }}>
        <div className="flex items-center gap-3 mb-2">
          <button onClick={() => currentChapterIndex > 0 && loadChapter(currentChapterIndex - 1)} disabled={currentChapterIndex === 0} style={{ color: theme.accent }} className="disabled:opacity-30">←</button>
          <div className="flex-1">
            <div className="h-0.5 rounded-full overflow-hidden" style={{ backgroundColor: `${theme.muted}40` }}>
              <div className="h-full transition-all" style={{ backgroundColor: theme.accent, width: `${totalChapters > 0 ? ((currentChapterIndex + currentPage / Math.max(totalPages, 1)) / totalChapters) * 100 : 0}%` }} />
            </div>
          </div>
          <button onClick={() => currentChapterIndex < totalChapters - 1 && loadChapter(currentChapterIndex + 1)} disabled={currentChapterIndex === totalChapters - 1} style={{ color: theme.accent }} className="disabled:opacity-30">→</button>
        </div>
        {showPageInfo && (
          <div className="flex justify-between text-xs font-sans" style={{ color: theme.muted }}>
            <span>Стр. {currentPage + 1} / {totalPages}</span>
            <span>Глава {currentChapterIndex + 1} / {totalChapters}</span>
            <span>Осталось ~{minutesLeft} мин</span>
          </div>
        )}
      </footer>

      {showTopPanel && <TopPanel bookId={bookId} chapters={chapters} currentChapterIndex={currentChapterIndex} onGoToChapter={(i) => { loadChapter(i); setShowTopPanel(false); }} onClose={() => setShowTopPanel(false)} />}
      {showSettings && <SettingsPanel settings={settings} onChange={setSettings} onClose={() => setShowSettings(false)} />}
      {showTTS && <TTSControlPanel onClose={() => { TTSService.stop(); setShowTTS(false); }} />}
      {translationTarget && <TranslationPopup text={translationTarget.text} position={translationTarget.position} bookId={bookId} onClose={() => setTranslationTarget(null)} />}
    </div>
  );
};
EOF

# ============================================
# src/screens/DictionaryScreen.tsx
# ============================================
cat > src/screens/DictionaryScreen.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { DictionaryService, DictionaryWord } from '../services/DictionaryService';

export const DictionaryScreen: React.FC<{ onBack: () => void }> = ({ onBack }) => {
  const [words, setWords] = useState<DictionaryWord[]>([]);
  const [filter, setFilter] = useState<'all' | 'review'>('all');

  useEffect(() => {
    (filter === 'review' ? DictionaryService.getWordsForReview() : DictionaryService.getAllWords()).then(setWords);
  }, [filter]);

  return (
    <div className="min-h-screen bg-parchment dark:bg-leather">
      <header className="px-6 pt-12 pb-6 border-b border-brass/20">
        <div className="max-w-4xl mx-auto">
          <button onClick={onBack} className="text-brass mb-4">←</button>
          <div className="flex items-center gap-3 mb-2">
            <div className="w-8 h-px bg-brass"></div>
            <span className="text-brass text-xs tracking-[0.3em] uppercase font-sans">Lexicon</span>
            <div className="flex-1 h-px bg-brass"></div>
          </div>
          <h1 className="font-serif text-4xl text-ink dark:text-parchment italic">Мой словарь</h1>
          <p className="text-ink-light dark:text-parchment/60 mt-2 font-sans text-sm">{words.length} слов</p>
        </div>
      </header>
      <div className="max-w-4xl mx-auto px-6 py-6">
        <div className="flex gap-2">
          <button onClick={() => setFilter('all')} className={`px-4 py-2 font-sans text-sm rounded-sm ${filter === 'all' ? 'bg-brass text-leather' : 'text-ink-light dark:text-parchment/70'}`}>Все</button>
          <button onClick={() => setFilter('review')} className={`px-4 py-2 font-sans text-sm rounded-sm ${filter === 'review' ? 'bg-brass text-leather' : 'text-ink-light dark:text-parchment/70'}`}>Повторение</button>
        </div>
      </div>
      <div className="max-w-4xl mx-auto px-6 pb-12">
        {words.length === 0 ? (
          <p className="text-center py-24 font-serif italic text-ink-light dark:text-parchment/60">Словарь пуст</p>
        ) : (
          <div className="space-y-3">
            {words.map(w => (
              <div key={w.id} className="p-4 bg-parchment-dark dark:bg-leather-light rounded-sm border border-brass/20">
                <div className="flex justify-between mb-2">
                  <div>
                    <p className="font-serif text-lg text-ink dark:text-parchment font-semibold">{w.word}</p>
                    <p className="font-serif text-base text-brass italic">{w.translation}</p>
                  </div>
                  <button onClick={async () => { await DictionaryService.deleteWord(w.id); setWords(words.filter(x => x.id !== w.id)); }} className="text-ink-light/40 hover:text-red-600">✕</button>
                </div>
                {w.context && <p className="font-serif text-sm text-ink-light dark:text-parchment/70 italic mb-3">«{w.context}»</p>}
                <div className="flex justify-between text-xs font-sans text-ink-light/60">
                  <span>Повторений: {w.review_count}</span>
                  <span>След: {new Date(w.next_review_at).toLocaleDateString('ru-RU')}</span>
                </div>
                {filter === 'review' && (
                  <div className="flex gap-2 mt-3">
                    <button onClick={async () => { await DictionaryService.markAsReviewed(w.id, false); setWords(await DictionaryService.getWordsForReview()); }} className="flex-1 py-2 bg-red-600/10 text-red-700 rounded-sm">Не помню</button>
                    <button onClick={async () => { await DictionaryService.markAsReviewed(w.id, true); setWords(await DictionaryService.getWordsForReview()); }} className="flex-1 py-2 bg-green-600/10 text-green-700 rounded-sm">Помню</button>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
EOF

# ============================================
# src/screens/OpdsBrowserScreen.tsx
# ============================================
cat > src/screens/OpdsBrowserScreen.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { OpdsService, OpdsFeed, OpdsCatalog } from '../services/OpdsService';
import { CatalogManager } from '../services/CatalogManager';
import { ImportService } from '../services/ImportService';

export const OpdsBrowserScreen: React.FC<{ onBack: () => void; onBookImported: () => void }> = ({ onBack, onBookImported }) => {
  const [catalogs, setCatalogs] = useState<OpdsCatalog[]>([]);
  const [current, setCurrent] = useState<OpdsCatalog | null>(null);
  const [feed, setFeed] = useState<OpdsFeed | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [history, setHistory] = useState<string[]>([]);
  const [downloading, setDownloading] = useState<string | null>(null);
  const [progress, setProgress] = useState(0);

  useEffect(() => { CatalogManager.init().then(() => CatalogManager.getAll()).then(setCatalogs); }, []);

  const loadFeed = async (url: string) => {
    setLoading(true); setError(null);
    try {
      setFeed(await OpdsService.fetchFeed(url));
      setHistory(h => [...h, url]);
    } catch (err) { setError((err as Error).message); }
    finally { setLoading(false); }
  };

  const handleDownload = async (entry: any) => {
    if (!entry.acquisitionUrl) return;
    setDownloading(entry.id); setProgress(0);
    try {
      const ext = entry.acquisitionType?.includes('epub') ? 'epub' : 'fb2';
      const fileName = `${entry.title.replace(/[^\w\s-]/g, '')}.${ext}`;
      const { data } = await OpdsService.downloadBook(entry.acquisitionUrl, fileName, setProgress);
      await ImportService.importFromBuffer(data, fileName);
      onBookImported();
    } catch (err) { alert('Ошибка: ' + (err as Error).message); }
    finally { setDownloading(null); }
  };

  if (!current) {
    return (
      <div className="min-h-screen bg-parchment dark:bg-leather">
        <header className="px-6 pt-12 pb-6 border-b border-brass/20">
          <button onClick={onBack} className="text-brass mb-4">←</button>
          <h1 className="font-serif text-4xl text-ink dark:text-parchment italic">Каталоги</h1>
        </header>
        <div className="max-w-4xl mx-auto px-6 py-6 space-y-3">
          {catalogs.map(c => (
            <button key={c.id} onClick={() => { setCurrent(c); loadFeed(c.url); }} className="w-full flex items-center gap-4 p-4 bg-parchment-dark dark:bg-leather-light border border-brass/20 rounded-sm hover:border-brass text-left">
              <div className="text-3xl">{c.icon || '📖'}</div>
              <div className="flex-1 min-w-0">
                <p className="font-serif text-lg text-ink dark:text-parchment">{c.title}</p>
                <p className="font-sans text-xs text-ink-light/60 truncate">{c.url}</p>
              </div>
              <span className="text-brass">→</span>
            </button>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-parchment dark:bg-leather">
      <header className="sticky top-0 z-10 px-6 pt-12 pb-4 bg-parchment/95 dark:bg-leather/95 backdrop-blur-sm border-b border-brass/20">
        <div className="max-w-4xl mx-auto flex items-center gap-3">
          <button onClick={() => {
            if (history.length > 1) { const h = history.slice(0, -1); setHistory(h); loadFeed(h[h.length - 1]); }
            else { setCurrent(null); setFeed(null); setHistory([]); }
          }} className="text-brass">←</button>
          <h1 className="font-serif text-xl text-ink dark:text-parchment italic truncate flex-1">{feed?.title || current.title}</h1>
        </div>
      </header>
      <div className="max-w-4xl mx-auto px-6 py-6">
        {loading && <div className="text-center py-12"><div className="text-brass animate-pulse font-serif italic">Загрузка...</div></div>}
        {error && <div className="p-4 bg-red-600/10 border border-red-600/30 rounded-sm text-center"><p className="text-red-700 text-sm">{error}</p></div>}
        {feed && !loading && (
          <>
            {feed.navigation.length > 0 && (
              <div className="mb-6">
                <h2 className="font-sans text-xs uppercase tracking-wider text-brass mb-3">Разделы</h2>
                <div className="grid grid-cols-2 gap-2">
                  {feed.navigation.map((n, i) => (
                    <button key={i} onClick={() => loadFeed(n.href)} className="p-3 text-left bg-brass/5 border border-brass/20 rounded-sm hover:bg-brass/10">
                      <p className="font-serif text-sm text-ink dark:text-parchment">{n.title}</p>
                    </button>
                  ))}
                </div>
              </div>
            )}
            <div className="space-y-3">
              {feed.entries.map(e => (
                <div key={e.id} className="flex gap-4 p-3 bg-parchment-dark dark:bg-leather-light border border-brass/20 rounded-sm">
                  <div className="w-16 aspect-[2/3] flex-shrink-0 bg-leather rounded-sm overflow-hidden">
                    {e.coverUrl ? <img src={e.coverUrl} alt="" className="w-full h-full object-cover" /> : <div className="w-full h-full flex items-center justify-center text-brass text-2xl">📖</div>}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="font-serif text-base text-ink dark:text-parchment line-clamp-2">{e.title}</p>
                    {e.author && <p className="font-sans text-xs text-brass mt-1">{e.author}</p>}
                    {e.acquisitionUrl && (
                      <button onClick={() => handleDownload(e)} disabled={downloading === e.id}
                        className="mt-2 px-3 py-1.5 bg-brass text-leather rounded-sm font-sans text-xs uppercase tracking-wider hover:bg-brass-light disabled:opacity-50">
                        {downloading === e.id ? `${progress}%` : '↓ Скачать'}
                      </button>
                    )}
                  </div>
                </div>
              ))}
              {feed.nextLink && <button onClick={() => loadFeed(feed.nextLink!)} className="w-full py-3 border border-brass/30 text-brass font-sans text-sm uppercase tracking-wider hover:bg-brass/5 rounded-sm">Ещё →</button>}
            </div>
          </>
        )}
      </div>
    </div>
  );
};
EOF

# ============================================
# Android-файлы
# ============================================
cat > android/app/src/main/java/com/bibliotheca/widget/BookWidget.kt << 'EOF'
package com.bibliotheca.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import com.bibliotheca.MainActivity
import com.bibliotheca.R

class BookWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) updateAppWidget(context, appWidgetManager, id)
    }

    companion object {
        private const val PREFS = "bibliotheca_widget"
        const val ACTION_OPEN = "com.bibliotheca.OPEN_BOOK"

        fun updateWidget(context: Context) {
            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(android.content.ComponentName(context, BookWidget::class.java))
            for (id in ids) updateAppWidget(context, mgr, id)
        }

        private fun updateAppWidget(context: Context, mgr: AppWidgetManager, id: Int) {
            val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.book_widget)
            views.setTextViewText(R.id.widget_title, prefs.getString("current_title", "Нет активной книги"))
            views.setTextViewText(R.id.widget_author, prefs.getString("current_author", "") ?: "—")
            views.setProgressBar(R.id.widget_progress, 100, prefs.getInt("current_percent", 0), false)
            views.setTextViewText(R.id.widget_percent, "${prefs.getInt("current_percent", 0)}%")

            val intent = Intent(context, MainActivity::class.java).apply {
                action = ACTION_OPEN
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pi = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.widget_root, pi)
            mgr.updateAppWidget(id, views)
        }
    }
}
EOF

cat > android/app/src/main/java/com/bibliotheca/WidgetPlugin.kt << 'EOF'
package com.bibliotheca

import android.content.Context
import com.bibliotheca.widget.BookWidget
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "WidgetBridge")
class WidgetPlugin : Plugin() {
    @PluginMethod
    fun updateCurrentBook(call: PluginCall) {
        val prefs = context.getSharedPreferences("bibliotheca_widget", Context.MODE_PRIVATE)
        prefs.edit().apply {
            putString("current_title", call.getString("title") ?: "")
            putString("current_author", call.getString("author") ?: "")
            putInt("current_percent", call.getInt("percent") ?: 0)
            apply()
        }
        BookWidget.updateWidget(context)
        call.resolve()
    }
}
EOF

cat > android/app/src/main/res/layout/book_widget.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="horizontal"
    android:padding="12dp"
    android:background="@drawable/widget_background"
    android:gravity="center_vertical">
    <LinearLayout android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:orientation="vertical">
        <TextView android:id="@+id/widget_title" android:layout_width="match_parent" android:layout_height="wrap_content" android:text="Нет активной книги" android:textColor="#E3DFD5" android:textSize="14sp" android:textStyle="bold" android:fontFamily="serif" android:maxLines="2" android:ellipsize="end" />
        <TextView android:id="@+id/widget_author" android:layout_width="match_parent" android:layout_height="wrap_content" android:text="—" android:textColor="#C2A878" android:textSize="11sp" android:layout_marginTop="2dp" android:maxLines="1" android:ellipsize="end" />
        <ProgressBar android:id="@+id/widget_progress" style="@android:style/Widget.ProgressBar.Horizontal" android:layout_width="match_parent" android:layout_height="4dp" android:layout_marginTop="8dp" android:max="100" android:progressDrawable="@drawable/widget_progress" />
        <TextView android:id="@+id/widget_percent" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="0%" android:textColor="#C2A878" android:textSize="10sp" android:layout_marginTop="2dp" />
    </LinearLayout>
</LinearLayout>
EOF

cat > android/app/src/main/res/drawable/widget_background.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <solid android:color="#1C1A18" />
    <corners android:radius="8dp" />
    <stroke android:width="1dp" android:color="#9C815E" />
</shape>
EOF

cat > android/app/src/main/res/drawable/widget_progress.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:id="@android:id/background">
        <shape><solid android:color="#2A2624" /><corners android:radius="2dp" /></shape>
    </item>
    <item android:id="@android:id/progress">
        <clip><shape><solid android:color="#C2A878" /><corners android:radius="2dp" /></shape></clip>
    </item>
</layer-list>
EOF

cat > android/app/src/main/res/xml/book_widget_info.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:initialLayout="@layout/book_widget"
    android:minWidth="250dp"
    android:minHeight="80dp"
    android:resizeMode="horizontal|vertical"
    android:updatePeriodMillis="1800000"
    android:widgetCategory="home_screen" />
EOF

# ============================================
# bitrise.yml
# ============================================
cat > bitrise.yml << 'EOF'
format_version: "13"
default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git

project_type: android

app:
  envs:
    - PROJECT_LOCATION: android
    - MODULE: app
    - BUILD_VARIANT: release
    - GRADLE_TASK: assembleRelease

meta:
  bitrise.io:
    stack: linux-docker-android-22.04

workflows:
  primary:
    steps:
      - activate-ssh-key@4: {}
      - git-clone@8: {}
      - nvm@1:
          inputs:
            - node_version: "20"
      - npm@1:
          inputs:
            - command: ci
      - script@1:
          title: Build web
          inputs:
            - content: |
                #!/bin/bash
                set -ex
                npm run build
      - script@1:
          title: Capacitor sync
          inputs:
            - content: |
                #!/bin/bash
                set -ex
                npx cap add android || true
                npx cap sync android
      - android-build@1:
          inputs:
            - project_location: $PROJECT_LOCATION
            - module: $MODULE
            - variant: $BUILD_VARIANT
            - gradle_task: $GRADLE_TASK
      - sign-apk@1:
          run_if: '{{getenv "BITRISEIO_ANDROID_KEYSTORE_URL" | ne ""}}'
      - deploy-to-bitrise-io@2: {}
EOF

# ============================================
# .gitignore
# ============================================
cat > .gitignore << 'EOF'
node_modules/
dist/
android/.gradle/
android/app/build/
android/capacitor-cordova-android-plugins/build/
*.log
EOF
echo "🎉 Готово!" 
