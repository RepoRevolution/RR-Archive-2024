<script setup>
import { onMounted } from 'vue';
import { useState } from '@/state';
import NUI from '@/utils/nui';
// Components
import KeysMenu from '@/components/KeysMenu.vue';
// State
const state = useState();

onMounted(() => {
    window.addEventListener('keydown', (e) => {
        if (state.isVisible && e.key === 'Escape') {
            NUI.send('closeUI');
        }
    });

    window.addEventListener('message', (e) => {
        const msg = e.data;
        if (msg.action === 'closeUI') {
            state.setVisible(false);
        } else if (msg.action === 'updateNearbyPlayers' && msg.players) {
            state.updateNearbyPlayers(msg.players);
        } else if (msg.action === 'updateKeys' && msg.keys) {
            state.updateKeys(msg.keys);
        } else if (msg.action === 'openKeysMenu') {
            state.setVisible(true);
        }
    });

    NUI.send('ready').then((response) => response.json()).then((data) => {
        state.updateLocales(data.locales);
    })
});
</script>

<template>
    <KeysMenu v-if="state.isVisible"/>
</template>