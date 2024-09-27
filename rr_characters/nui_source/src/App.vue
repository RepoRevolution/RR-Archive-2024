<script setup>
import { onMounted, ref } from "vue";
import NUI from '@/utils/nui';
import CharacterInformation from "@/views/TitleScreen.vue";
import TitleScreen from "@/views/TitleScreen.vue";
import UserDropdown from "@/components/UserDropdown.vue";

onMounted(() => {
    window.addEventListener('message', (e) => {
        const resData = e.data;
        switch (resData.action) {
          case 'openUI':
            NUI.send('loaded').then((data) => {});
            break;
          /*  case 'closeUI':
                config.setVisible(false);
                break;
            case 'openUI':
                config.setVisible(true);
                console.log(JSON.stringify(resData));
                characters.setSlots(resData.slots);
                characters.setCharacters(resData.characters);
                NUI.send('loaded').then((data) => {});
                break;*/
        }
        
    });

    NUI.send('ready').then((data) => {

    });
});
</script>

<template>
  <UserDropdown />
  <TitleScreen></TitleScreen>
</template>