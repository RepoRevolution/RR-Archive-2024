<script setup>
defineProps([
    'style',
    'fullWidth',
    'primary',
    'secondary'
])
defineEmits([
    'onClick'
])


</script>

<style scoped>
.button {

}

.primary {
  background-color: #E0A800;
  color: white;
  font-weight: bold;
}
.secondary {
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
}
</style>

<template>
  <button
      :class="`button text-center py-4 rounded-2xl bold px-8 ${fullWidth ? 'w-full' : ''} ${secondary ? 'secondary' : 'primary'}`"
      @click="$emit('onClick')"
      :style="style"
  >
    <slot />
  </button>
</template>