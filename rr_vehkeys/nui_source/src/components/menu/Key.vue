<script setup>
import { ref } from 'vue';
import KeyIcon from '@/components/menu/KeyIcon.vue';

const props = defineProps({
    data: Object,
    index: Number,
    setCurrentKey: Function
})

let isActive = ref(false);

const handleCurrentKey = () => {
    isActive.value = true;
    props.setCurrentKey(props.data, props.index);
}

defineExpose({ isActive });
</script>

<template>
    <div class="key" :class="{ active: isActive }" @click="handleCurrentKey">
        <div class="key_stolen_icon" v-if="data.stolen">
            <i class="fa-solid fa-gun"></i>
        </div>
        <div class="key_icon">
            <i class="fas fa-key"></i>
        </div>
        <div class="key_label">
            {{ data.type == 3 ? data.label : data.plate }}
        </div>
        <div class="key_type_info">
            <KeyIcon :type="data.type" />
        </div>
    </div>
</template>

<style scoped>
.key {
    width: 6.5vw;
    height: 100%;
    position: relative;
    padding: .55vw;
    display: flex;
    flex-shrink: 0;
    flex-direction: column;
    justify-content: space-around;
    align-items: center;
    gap: .5vw;
    color: var(--theme-color);
    cursor: pointer;
    transition: all .25s ease-in-out;
}

.key_stolen_icon {
    position: absolute;
    top: 0;
    right: 0;
    margin: .1vh .2vw;
    padding: .2vw;
    font-size: .65vw;
    color: rgba(255, 0, 0, .75);
    border: 2px solid rgba(255, 0, 0, .75);
    border-radius: 50%;
}

.key_label {
    height: 1.5vw;
    margin-bottom: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    font-size: .65vw;
    font-weight: 600;
    text-align: center;
    pointer-events: none;
    transition: all .25s cubic-bezier(0.075, 0.82, 0.165, 1);
}

.key_icon {
    pointer-events: none; 
    font-size: 2.5vw;
    margin-bottom: 0;
}

.key_type_info {
    margin-bottom: .5vw;
    font-size: 1vw;
    text-transform: uppercase;
    color: white;
    opacity: .35;
}

.key:hover, .key.active {
    background-color: var(--theme-color);
    color: var(--color-dark);
}

.key:hover .key_label, .key.active .key_label {
    margin-bottom: .5vw;
}

.key:hover .key_type_info, .key.active .key_type_info {
    opacity: 1;
    color: var(--color-dark);
}
</style>