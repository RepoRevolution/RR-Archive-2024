import { createPinia } from 'pinia';

export function registerPlugins(app) {
    const pinia = createPinia();
    app.use(pinia);
}