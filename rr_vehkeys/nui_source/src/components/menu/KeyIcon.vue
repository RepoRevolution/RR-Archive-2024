<script setup>
const props = defineProps({
    type: Number
})
</script>

<template>
    <span v-if="type == 0">
        <i class="fas fa-clock"></i>
    </span>
    <span v-else-if="type == 1">
        <i class="fas fa-check"></i>
    </span>
    <span v-else-if="type == 2">
        <i class="fas fa-crown"></i>
    </span>
    <span v-else-if="type == 3">
        <i class="fas fa-users"></i>
    </span>
</template>