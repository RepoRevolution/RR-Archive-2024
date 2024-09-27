<script setup>
import { ref } from 'vue';

const props = defineProps({
    data: Object,
    index: Number,
    activateSort: Function
})

let isActive = ref(false);
let order = ref(false);

const handleActivateSort = () => {
    if (!isActive.value) {
        isActive.value = true;
        order.value = false;
    } else { order.value = !order.value; }
    
    props.activateSort(props.index, order.value ? 1 : -1);
}

defineExpose({ isActive });
</script>

<template>
    <div class="sort_type" :class="{ active: isActive }" @click="handleActivateSort">
        {{ data.label }}
        <div class="sort_type_icon" v-if="isActive">
            <i v-if="order" class="fa-solid fa-arrow-down-long"></i>
            <i v-else class="fa-solid fa-arrow-up-long"></i>
        </div>
    </div>
</template>

<style scoped>
.sort_type {
    display: flex;
    justify-content: space-around;
    align-items: center;
    text-transform: uppercase;
    font-size: .8vw;
    font-weight: 500;
    color: var(--color-light-offset);
    opacity: .35;
    transition: all .25s ease-in-out;
    cursor: pointer;
}

.sort_type:hover {
    opacity: .75;
}

.sort_type_icon {
    margin: 0 .2vw;
    font-size: .7vw;
}

.sort_type.active {
    color: var(--theme-color);
    opacity: 1;
}
</style>