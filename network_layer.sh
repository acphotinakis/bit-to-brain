#!/bin/bash
# ==========================================================
# Setup LaTeX folder structure for Chapter 4: Network Layer
# Author: ChatGPT
# ==========================================================

BASE_DIR="/home/stu5/s0/acp7795/Documents/bit-to-brain/latex-notes/computer-networks/network-layer"
SECTIONS_DIR="$BASE_DIR/sections"

# Create base directories
mkdir -p "$SECTIONS_DIR"

# ---------------------------
# Helper function
# ---------------------------
create_section() {
  local section_dir="$SECTIONS_DIR/$1"
  local main_file="$section_dir/$1.tex"
  shift
  mkdir -p "$section_dir"
  touch "$main_file"
  for subsection in "$@"; do
    touch "$section_dir/$subsection.tex"
  done
}

# ---------------------------
# Create all section folders and files
# ---------------------------

# 4.1
create_section "4_1_overview_of_network_layer" \
  "4_1_1_forwarding_and_routing_the_data_and_control_planes" \
  "4_1_2_network_service_model"

# 4.2
create_section "4_2_whats_inside_a_router" \
  "4_2_1_input_port_processing_and_destination_based_forwarding" \
  "4_2_2_switching" \
  "4_2_3_output_port_processing" \
  "4_2_4_where_does_queuing_occur" \
  "4_2_5_packet_scheduling"

# 4.3
create_section "4_3_the_internet_protocol_ip_ipv4_addressing_ipv6_and_more" \
  "4_3_1_ipv4_datagram_format" \
  "4_3_2_ipv4_addressing" \
  "4_3_3_network_address_translation_nat" \
  "4_3_4_ipv6"

# 4.4
create_section "4_4_generalized_forwarding_and_sdn" \
  "4_4_1_match" \
  "4_4_2_action" \
  "4_4_3_openflow_examples_of_match_plus_action_in_action"

# 4.5
create_section "4_5_middleboxes"

# 4.6
create_section "4_6_summary"

# Main chapter file
touch "$BASE_DIR/chapter4_network_layer_data_plane.tex"

# Optional figures directory
mkdir -p "$BASE_DIR/figures"

echo "✅ LaTeX directory structure successfully created!"
echo "Base: $BASE_DIR"
