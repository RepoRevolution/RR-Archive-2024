import { defineStore } from 'pinia';

export const useConfig = defineStore('config', {
    state: () => {
        return {
            isVisible: false,
            validationRules: {},
            locale: [],
            nationalities: [],
            spawnPoints: [],
            classes: [],
        };
    },

    actions: {
        setVisible(value) {
            this.isVisible = value;
        },
        loadLocale(locale) {
            this.locale = locale;
        },
        loadValidationRules(rules) {
            this.validationRules = rules;
        },
        loadNationalities(nationalities) {
            this.nationalities = nationalities;
        },
        loadSpawnPoints(spawnPoints) {
            this.spawnPoints = spawnPoints;
        },
        loadClasses(classes) {
            this.classes = classes;
        }
    }
});