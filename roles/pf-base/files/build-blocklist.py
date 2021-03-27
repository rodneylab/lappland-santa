#!/usr/local/bin/python3 -tt
# -*- coding: utf-8 -*-

from netaddr import cidr_merge, IPNetwork, IPSet
import sys


def get_blocklist(filename):
    input_file = open(filename, 'r')
    result = []
    for line in input_file:
        result.append(IPNetwork(line))
    input_file.close()
    return cidr_merge(result)


def apply_allowlist_to_blocklist(blocklist, allowlist_filename):
    allowlist_file = open(allowlist_filename, 'r')
    blocklist_ipset = IPSet(blocklist)
    for line in allowlist_file:
        if IPNetwork(line) in blocklist_ipset:
            print(line + ' is in blocklist, removing it!')
            blocklist_ipset.remove(IPNetwork(line))
    blocklist_ipset.compact()
    return blocklist_ipset


def generate_output_file(blocklist_ipset, output_filename):
    output_file = open(output_filename, 'w')
    for cidr in blocklist_ipset.iter_cidrs():
        output_file.write(str(cidr) + '\n')
    output_file.close()
    return


def main():
    if len(sys.argv) < 3:
        print("usage: ./build-blocklist.py blocklist_file allowlist_file "
              + "output_file")
        sys.exit(1)

    blocklist_filename = sys.argv[1]
    allowlist_filename = sys.argv[2]
    output_filename = sys.argv[3]

    blocklist = get_blocklist(blocklist_filename)
    filtered_blocklist_set = apply_allowlist_to_blocklist(
        blocklist, allowlist_filename)
    generate_output_file(filtered_blocklist_set, output_filename)


if __name__ == '__main__':
    main()
