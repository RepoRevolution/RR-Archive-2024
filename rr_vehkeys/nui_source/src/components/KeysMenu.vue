<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import NUI from '@/utils/nui';
import { useState } from '@/state';
// Components
import KeySort from '@/components/menu/KeySort.vue';
import Key from '@/components/menu/Key.vue';
// State
const state = useState();
const currentKey = ref(null);
const hoveredKey = ref(null);

const key = ref(null);
const setHoveredKey = (data, index) => {
    if (data == undefined || index == undefined) {
        hoveredKey.value = null;
    } else {
        if (currentKey.value == null || currentKey.value.index != index) {
            hoveredKey.value = {
                data: data,
                index: index
            };
        }
    }
}

const setCurrentKey = (data, index) => {
    setHoveredKey();
    if (data === undefined || index === undefined) {
        currentKey.value = null;
    } else {
        currentKey.value = {
            data: data,
            index: index
        };
    }

    const array = key.value;
    array.forEach((key, i) => {
        if (index === undefined || i != index) {
            key.isActive = false;
        }
    });
}

const search = {
    data: ref(''),
    clear: () => search.data.value = ''
}

const keySort = ref(null);
const sorting = {
    types: [
        { type: 0, label: state.locales.ui_plate },
        { type: 1, label: state.locales.ui_type },
        { type: 2, label: state.locales.ui_stolen }
    ],
    activate: (type, order) => {
        setCurrentKey();
        state.keys.sort((a, b) => {
            if (type == 0) {
                if (a.type == 3) {
                    return 1;
                }
                return order * a.plate.localeCompare(b.plate)
            } else if (type == 1) {
                return order * (b.type - a.type);
            } else if (type == 2) {
                let aStolen = a.stolen ? 1 : 0;
                let bStolen = b.stolen ? 1 : 0;
                return order * (aStolen - bStolen);
            }
        });

        const array = keySort.value;
        array.forEach((sort, index) => {
            if (index != type) {
                sort.isActive = false;
            }
        });
    },
    deactivate: () => {
        keySort.value.forEach(sort => sort.isActive = false);
    }
}

const filterKeys = computed(() => {
    const query = search.data.value.toLowerCase();
    return state.keys.filter(key => {
        return key.plate.toLowerCase().includes(query) || key.label.toLowerCase().includes(query);
    });
});

const keyOptions = {
    ['GIVE_PERM']: [ 2 ],
    ['GIVE_TEMP']: [ 2, 1 ],
    ['REVOKE_PERM']: [ 2 ],
    ['REMOVE']: [ 1, 0 ],

    giveCopyKey: (keyType) => {
        if (currentKey.value != null){
            NUI.send('giveCopyKey', {
                target: null,
                vehicle: {
                    plate: currentKey.value.data.plate,
                    model: currentKey.value.data.model
                },
                keyType: keyType
            });
        }
    },

    revokePermKeys: () => {
        if (currentKey.value != null){
            NUI.send('revokePermKeys', {
                vehicle: {
                    plate: currentKey.value.data.plate,
                    model: currentKey.value.data.model
                }
            });
        }
    },

    removeKey: () => {
        if (currentKey.value != null){
            NUI.send('removeKey', {
                vehicle: {
                    plate: currentKey.value.data.plate,
                    model: currentKey.value.data.model
                },
                keyType: currentKey.value.data.type
            });
        }
    }
}

watch(() => state.keys, () => {
    setCurrentKey();
});

watch(() => search.data.value, () => {
    setHoveredKey();
    setCurrentKey();
});

onMounted(() => {
    document.getElementById('keysList').addEventListener('wheel', (e) => {
        e.preventDefault();
        keysList.scrollLeft += e.deltaY;
    });
})
</script>

<template>
    <div class="keys_menu" @contextmenu="setCurrentKey()">
        <div class="keys_info">
            <div class="keys_info_labels">
                <div class="keys_info_label" v-if="currentKey">
                    {{ currentKey.data.label + ' - ' + currentKey.data.plate }}
                </div>
                <div class="keys_info_label" :class="{ hovered: currentKey }" v-if="hoveredKey">
                    {{ hoveredKey.data.label + ' - ' + hoveredKey.data.plate }}
                </div>
            </div>
            <div class="keys_info_options" v-if="currentKey && currentKey.data.type != 3">
                <div class="keys_container_header">{{ state.locales.ui_options }}</div>
                <div class="keys_info_options_list">
                    <!-- <div class="keys_info_options_nearest" v-if="keyOptions['GIVE_PERM'].includes(currentKey.data.type) || keyOptions['GIVE_TEMP'].includes(currentKey.data.type)">
                        <i class="fa-solid fa-arrow-right"></i>
                        {{ JSON.stringify(state.nearbyPlayers) }}
                        [2] Jack Jones
                    </div> -->
                    <button class="keys_info_option" v-if="keyOptions['GIVE_PERM'].includes(currentKey.data.type)" @click="keyOptions.giveCopyKey(1)">
                        <i class="fas fa-check"></i>
                        <span>{{ state.locales.ui_give_permanent_key }}</span>
                    </button>
                    <button class="keys_info_option" v-if="keyOptions['GIVE_TEMP'].includes(currentKey.data.type)" @click="keyOptions.giveCopyKey(0)">
                        <i class="fas fa-clock"></i>
                        <span>{{ state.locales.ui_give_temporary_key }}</span>
                    </button>
                    <button class="keys_info_option" v-if="keyOptions['REVOKE_PERM'].includes(currentKey.data.type)" @click="keyOptions.revokePermKeys">
                        <i class="fa-solid fa-rotate-left"></i>
                        <span>{{ state.locales.ui_revoke_permanent_keys }}</span>
                    </button>
                    <button class="keys_info_option" v-if="keyOptions['REMOVE'].includes(currentKey.data.type)" @click="keyOptions.removeKey">
                        <i class="fa-solid fa-xmark"></i>
                        <span>{{ state.locales.ui_drop_key }}</span>
                    </button>
                </div>
            </div>
        </div>
        <div class="keys_container">
            <div class="keys_container_header">{{ state.locales.ui_keys }}</div>
            <div class="keys_container_list">
                <div class="keys_container_settings">
                    <div class="keys_container_search">
                        <input type="text" :placeholder="state.locales.ui_search" maxlength="8" v-model="search.data.value" />
                        <span id="resetSearch" v-if="search.data.value && search.data.value.length > 0" @click="search.clear">
                            <i class="fa-solid fa-xmark"></i>
                        </span>
                    </div>
                    <div class="keys_container_sorting">
                        <KeySort v-for="(data, index) in sorting.types"
                            :data="data" :index="index"
                            :activateSort="sorting.activate"
                            :key="index" ref="keySort"
                        />
                    </div>
                </div>
                <div id="keysList">
                    <Key v-if="filterKeys.length > 0"
                        v-for="(data, index) in filterKeys"
                        :data="data" :index="index"
                        :key="index" ref="key"
                        :setCurrentKey="setCurrentKey"
                        @mouseover="setHoveredKey(data, index)"
                        @mouseleave="setHoveredKey()"
                    />
                    <div id="noKeys" v-else>{{ state.locales.ui_no_keys }}</div>
                </div>
            </div>
        </div>
        <div class="keys_menu_help">
            <div class="keys_menu_help_element">
                <div class="keys_menu_help_element_text">{{ state.locales.ui_select_key }}</div>
                <div class="keys_menu_help_element_icon">        
                    <svg viewBox="0 0 139 230" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M0 178C2 216 43.5 230 70.5 230C97.5 230 138.5 211.5 138.5 178V99.5H0V178Z" fill="black" fill-opacity="0.35"/>
                        <path d="M66.5 88.5H0V47C0 22 21 0 66.5 0V88.5Z" fill="black" fill-opacity="0.35"/>
                        <path d="M74.5 0V88.5H138.5V47C138.5 22 116 0 74.5 0Z" fill="black" fill-opacity="0.35"/>
                        <path d="M66.5 89V0C23 0 1 20 0 45V89H66.5Z" fill="#E9DFB8"/>
                    </svg>
                </div>
            </div>
            <div class="keys_menu_help_element">
                <div class="keys_menu_help_element_text">{{ state.locales.ui_unselect_key }}</div>
                <div class="keys_menu_help_element_icon">
                    <svg viewBox="0 0 139 230" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M0 178C2 216 43.5 230 70.5 230C97.5 230 138.5 211.5 138.5 178V99.5H0V178Z" fill="black" fill-opacity="0.35"/>
                        <path d="M66.5 88.5H0V47C0 22 21 0 66.5 0V88.5Z" fill="black" fill-opacity="0.35"/>
                        <path d="M74.5 0V88.5H138.5V47C138.5 22 116 0 74.5 0Z" fill="black" fill-opacity="0.35"/>
                        <path d="M72 89V0C115.5 0 137.5 20 138.5 45V89H72Z" fill="#E9DFB8"/>
                    </svg>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.keys_menu {
    position: fixed;
    bottom: 5vh;
    left: 50%;
    transform: translateX(-50%);
}

.keys_info {
    display: flex;
    flex-direction: column-reverse;
}

.keys_info_labels {
    display: flex;
    margin-left: 1.5vw;
    padding: .5vw;
    font-size: 1vw;
    color: var(--color-light);
    font-weight: 600;
    text-shadow: 0 0 2px var(--color-dark);
}

.keys_info_label.hovered {
    margin-left: .3vw;
    color: var(--color-light-offset);
    font-weight: 400;
    font-style: italic;
}

.keys_info_options {
    max-width: 40%;
    display: flex;
    flex-shrink: 0;
    background-color: var(--color-dark);
}

.keys_info_options_list {
    width: 100%;
    padding: .5vw;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.keys_info_options_nearest {
    padding: .25vw;
    text-wrap: nowrap;
    overflow: hidden;
    font-size: .8vw;
    font-weight: 600;
    color: var(--color-light);
    background-color: var(--color-dark-offset);
    border: none;
    outline: 0;
}

.keys_info_option {
    margin-top: .25vw;
    display: flex;
    align-items: baseline;
    text-align: left;
    text-transform: uppercase;
    font-size: .8vw;
    font-weight: 600;
    color: var(--color-light-offset);
    background: none;
    opacity: .35;
    border: none;
    cursor: pointer;
    transition: all .25s ease-in-out;
}

.keys_info_option i {
    min-width: 1.75vw;
    padding: .25vw .35vw;
    text-align: center;
}

.keys_info_option:hover {
    opacity: .75;
}

.keys_container {
    width: 45vw;
    position: relative;
    display: flex;
    flex-shrink: 0;
    justify-content: center;
}

.keys_container_header {
    padding: .5vw;
    transform: rotate(-180deg);
    font-size: .8vw;
    font-weight: 700;
    text-transform: uppercase;
    writing-mode: tb-rl;
    text-align: center;
    color: var(--color-dark);
    background-color: var(--theme-color);
}

.keys_container_list {
    width: 43vw;
    position: relative;
    display: flex;
    flex-direction: column;
    flex-grow: 0;
    background-color: var(--color-dark);
}

.keys_container_settings {
    display: flex;
    justify-content: space-between;
}

.keys_container_search {
    position: relative;
}

.keys_container_search > input[type=text] {
    width: 7.75vw;
    margin: .35vw;
    padding: .25vw;
    font-size: .8vw;
    font-weight: 600;
    color: var(--theme-color);
    background-color: var(--color-dark-offset);
    border: none;
    outline: 0;
}

.keys_container_search > input[type=text]::placeholder {
    color: var(--color-light-offset);
    opacity: .5;
    transition: all .25s ease-in-out;
}

.keys_container_search:hover > input[type=text]::placeholder {
    opacity: .75;
}

.keys_container_search > #resetSearch {
    position: absolute;
    top: .4vw;
    right: .6vw;
    font-size: 1vw;
    color: var(--theme-color);
    cursor: pointer;
}

.keys_container_sorting {
    display: flex;
    padding: .5vw;
    gap: .5vw;
}

#keysList {
    height: 20vh;
    display: flex;
    overflow-y: scroll;
    gap: 0;
}

#keysList::-webkit-scrollbar {
    display: none;
}

#keysList > #noKeys {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 1vw;
    font-weight: 700;
    color: var(--theme-color);
}

.keys_menu_help {
    padding-top: .5vw;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    color: var(--theme-color);
    gap: .25vw;
}

.keys_menu_help_element {
    width: 8vw;
    display: flex;
    justify-content: flex-end;
    text-transform: uppercase;
    font-size: .9vw;
    font-weight: 700;
    gap: .25vw;
}

.keys_menu_help_element_text {
    white-space: pre;
    text-shadow: 0 0 2px var(--color-dark);
}

.keys_menu_help_element_icon, .keys_menu_help_element_icon svg {
    width: 1.15vw;
    height: 1.15vw;
}
</style>