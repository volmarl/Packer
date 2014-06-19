# (c) 2014, GoGrid, LLC

import re

import ansible.utils as utils
import ansible.errors as errors


def flatten(terms):
    ret = []
    for term in terms:
        if isinstance(term, list):
            ret.extend(term)
        else:
            ret.append(term)
    return ret


class LookupModule(object):

    def __init__(self, basedir=None, **kwargs):
        self.basedir = basedir
        self.pattern = None

    def parse_pos_args(self, args):
        sargs = args.strip().split(' ', 1)
        if len(sargs) != 2:
            raise errors.AnsibleError(
                    "Can't parse pattern/items from %r" % args)
        try:
            pattern_raw = sargs[0]
            #print "***** pattern_raw: %r" % pattern_raw
            if pattern_raw is None:
                raise errors.AnsibleError("pattern missing")
            self.pattern = re.compile(pattern_raw)
        except re.error:
            raise errors.AnsibleError(
                "can't parse pattern, '%r', as regex"
                    % pattern_raw
            )
        return sargs[1]

    def parse_kv_args(self, args):
        try:
            pattern_raw = args.pop("pattern", None)
            #print "***** pattern_raw: %r" % pattern_raw
            if pattern_raw is None:
                raise errors.AnsibleError("pattern missing")
            self.pattern = re.compile(pattern_raw)
        except re.error:
            raise errors.AnsibleError(
                "can't parse pattern, '%r', as regex"
                    % pattern_raw
            )
        return args.pop("items", None)

    def run(self, terms, inject=None, **kwargs):
        results = []
        #print '******terms:', terms
        first_arg = terms.strip().split()[0]
        if first_arg.startswith('pattern=') or first_arg.startswith('items='):
            terms = self.parse_kv_args(utils.parse_kv(terms))
        else:
            terms = self.parse_pos_args(terms)

        terms = utils.listify_lookup_plugin_terms(terms, self.basedir, inject)
        #print "*****pattern:", self.pattern, "\n*****items:", terms

        if not isinstance(terms, list):
            raise errors.AnsibleError("with_matching_items expects a list")

        new_terms = flatten(terms)
        for term in new_terms:
            if self.pattern.search(term):
                results.append(term)
        #print "*****results:", results
        return zip(range(len(results)), results)
