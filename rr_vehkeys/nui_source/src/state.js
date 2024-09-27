import { defineStore } from 'pinia';

export const useState = defineStore('state', {
    state: () => {
        return {
            isVisible: false,
            locales: {},
            keys: [],
            nearbyPlayers: []
        };
    },

    actions: {
        setVisible(boolean) {
            this.isVisible = boolean;
        },
        updateLocales(data) {
            this.locales = data;
        },
        updateKeys(data) {
            this.keys = data;
        },
        updateNearbyPlayers(data) {
            this.nearbyPlayers = data;
        }
    }
});