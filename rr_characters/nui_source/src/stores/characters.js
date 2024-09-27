import { defineStore } from 'pinia';

export const useCharacters = defineStore('slots', {
    state: () => {
        return {
            slots: 0,
            characters: [],
            availableSlots: 0,
        };
    },

    actions: {
        setSlots(slots) {
            this.slots = slots;
            this.availableSlots = this.slots - this.characters.length;
        },
        setCharacters(characters) {
            this.characters = characters;
            this.availableSlots = this.slots - this.characters.length;
        },
    }
});