import { createApp } from 'vue';
import { registerPlugins } from '@/utils/plugins.js';

import '@/styles.css';
import App from '@/App.vue';

const app = createApp(App);
registerPlugins(app);
app.mount('#app');