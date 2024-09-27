<script setup>
import Button from "@/components/Button.vue";
import NewsSlide from "@/components/NewsSlide.vue";

import infoPlaceholderImage from "@/assets/info-ph.png";
import asd from "@/assets/bg-hero.png";
import arrowLeft from "@/assets/arrow-left.svg";
import arrowRight from "@/assets/arrow-right.svg";

import {ref} from "vue";


const activePage = ref("news");
const activeSlide = ref(0);
const showText = ref(true);
const canChangeSlide = ref(true);
const heroNews = ref([
  {
    title: "Nowy Bar!",
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    backgroundImage: infoPlaceholderImage
  },{
    title: "Nowa aktualizacja",
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    backgroundImage: asd
  },{
    title: "Nowa aktualizacja",
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    backgroundImage: infoPlaceholderImage
  }
]);

const changePage = () => {
  console.log("test");
  //add 1 to activeSlide
}

const setActiveSlide = async (index) => {
  if(!canChangeSlide.value) return;
  if(index < 0) index = heroNews.value.length - 1;
  if(index >= heroNews.value.length) index = 0;
  canChangeSlide.value = false;
  showText.value = false;

  setTimeout(() => {
    activeSlide.value = index;
  }, 500);
  setTimeout(() => {
    showText.value = true;
    canChangeSlide.value = true;
  }, 1000);
}

const expandText = () => {
  if(!canChangeSlide.value) return;
  console.log("expand");
}

</script>

<style scoped>

.background{
  background: url(@/assets/bg-hero.png) no-repeat center center fixed;
  background-size: cover;

}

.main-container {
  width: 960px;
  height: 612px;
  margin-left: auto;
  margin-right: auto;
  margin-top: 214px;
}

.news-controls{
  position: absolute;
  bottom: 30px;
  left: 0;
  right: 0;
  display: flex;
  justify-content: center;
}

</style>

<template>

  <div class="w-full h-full fixed z-0 fixed background">
    <div class="main-container z-20 relative" >
        <!--      Navigation      -->
        <nav class="flex flex-row gap-4 " >
          <Button :style="{padding: '16px 128px'}" :onClick="changePage" >Graj</Button>
          <Button full-width="true" secondary="true" :onClick="changePage" >Lista zmian</Button>
          <Button full-width="true" secondary="true" :onClick="changePage" >Regulamin</Button>
          <Button full-width="true" secondary="true" :onClick="changePage" >Ustawienia</Button>
        </nav>
      <!--      News      -->
      <div class="news-container relative w-full h-[540px] mt-4 overflow-clip rounded-2xl">
        <NewsSlide
            v-for="(news, index) in heroNews"
            :key="index"
            :index="index"
            :activeIndex="activeSlide"
            :newsData="news"
        />

        <div :class="`absolute bottom-0 left-0 right-0 p-8 h-60 backdrop-blur-md bg-[rgba(0,0,0,0.25)]`" >
          <p style="transition: opacity 0.5s;" :class="`${showText ? 'opacity-100' : 'opacity-0'} news-text text-white text-3xl font-[900] `" >{{heroNews[activeSlide].title}}</p>
          <span style="transition: opacity 0.5s;" :class="`${showText ? 'opacity-100' : 'opacity-0'} news-text block my-4 text-white font-[200] whitespace-nowrap overflow-ellipsis overflow-hidden`" >{{heroNews[activeSlide].content}} asdasdasdasd asd asd asd asd ads ads a ds asd asd ads ads ds dsa ads das ads asd asd</span>
          <button :class="`${showText ? 'opacity-100' : 'opacity-0'} float-right`" style="transition: opacity 0.5s; color: rgba(255, 255, 255, 0.75);" >Czytaj więcej</button>
        </div>
        <div class="absolute left-0 right-0 bottom-8 flex flex-row justify-center gap-2" >
          <img :src="arrowLeft" class="w-6 h-6 cursor-pointer mr-2" @click="setActiveSlide(activeSlide - 1)" />
          <div v-for="(news, index) in heroNews" :class="`${index === activeSlide ? 'w-4 h-4 my-1' : 'w-2 h-2 my-2'} rounded-xl bg-white cursor-pointer`" @click="setActiveSlide(index)" />
          <img :src="arrowRight" class="w-6 h-6 cursor-pointer ml-2" @click="setActiveSlide(activeSlide + 1)" />
        </div>
      </div>


    </div>
  </div>

</template>