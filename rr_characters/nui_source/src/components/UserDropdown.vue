<script setup>

import dropdownIcon from "@/assets/dropdown.svg";
import avatarPh from "@/assets/avatar-ph.png";

</script>

<style scoped>

</style>

<template>
  <div class="absolute top-8 right-8 flex flex-row z-50" >
    <img class="w-12 h-12 rounded-xl mx-2" :src="avatarPh" alt="User Avatar" />
    <p class="text-2xl font-[900] py-2 px-2 text-white" >Kasellix</p>
    <img :src="dropdownIcon" class="w-8 h-8 my-2" />
  </div>
</template>