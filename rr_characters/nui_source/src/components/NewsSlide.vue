<script setup>

defineProps([
    'newsData',
    'index',
    'activeIndex'
])

</script>


<style scoped>

.news-container{
  width: 100%;
  height: 100%;
  transition: transform 0.5s;
}

</style>

<template>
  <div
      :class="`absolute news-container bg-cover bg-center`"
      :style="{
         backgroundImage: `url(${newsData.backgroundImage})`,
         transform: `translateX(${
            100 * (index - activeIndex)
         }%)`
      }" >


  </div>
</template>