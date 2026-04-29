
extern void nma_get_resource(void);
__attribute__((constructor)) void register_resources_internal()
{
    nma_get_resource();
}