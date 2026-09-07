// main.js
import Reveal from './reveal.js/dist/reveal.esm.js';

// Import plugins
import Markdown from './reveal.js/plugin/markdown/markdown.esm.js';
import Highlight from './reveal.js/plugin/highlight/highlight.esm.js';
import Math from './reveal.js/plugin/math/math.esm.js';
import Notes from './reveal.js/plugin/notes/notes.esm.js';
import Search from './reveal.js/plugin/search/search.esm.js';
import Zoom from './reveal.js/plugin/zoom/zoom.esm.js';

// Initialize Reveal.js
// Detect whether we're in print-pdf mode (legacy Reveal.js query)
const isPrintPDF = /print-pdf/gi.test( window.location.search );

// Print-friendly overrides (only applied when ?print-pdf is present)
const printOverrides = isPrintPDF ? {
    view: 'print',
    pdfSeparateFragments: true,
    // Use a printable resolution that works well for most PDF generators
    width: 1024,
    height: 768,
    margin: 0
} : {};

const revealConfig = {
    width: 1920,
    height: 1080,
    hash: true,
    center: false,
    progress: true,
    slideNumber: true,
    transition: 'fade', // none/fade/slide/convex/concave/zoom
    backgroundTransition: 'fade', // none/fade/slide/convex/concave/zoom
    transitionSpeed: 'default', // default/fast/slow
    plugins: [Markdown, Highlight, Math.KaTeX, Notes, Search, Zoom],
    history: true,
    pdfSeparateFragments: false,
    fragments: true,
    fragmentInURL: true,
    katex: {
        trust: true,
        strict: false,
        version: 'latest',
        delimiters: [
            { left: '$$', right: '$$', display: true },
            { left: '$', right: '$', display: false },
            { left: '\\(', right: '\\)', display: false },
            { left: '\\[', right: '\\]', display: true },
        ],
        ignoredTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'],
    }
};

// Merge print overrides last so they take precedence
Reveal.initialize({ ...revealConfig, ...printOverrides });

// When printing, ensure the layout is performed once Reveal is ready
if( isPrintPDF ) {
    Reveal.on( 'ready', () => {
        // Allow a short delay for fonts/images and then layout
        setTimeout(() => {
            try { Reveal.layout(); } catch (e) { /* noop */ }
        }, 120);
    });
}